import parsecnf as rd
# Tested and works
def create_literal_memberships(filename):
    """
    Creates an array of literal memberships based on a given CNF file.
   
    Args:
    filename (string): A problem .cnf file
   
    Returns:
    literal_memberships: A list of literals, stacked and indexable from 0 to num_vars, where 0 is the first literal = l1
    Ex.: literal_memberships[2*num_vars] = literal_memberships[-max_var] do not just literal_memberships[-16] etc. wrong
    """
    num_vars, clauses = rd.read_dimacs(filename)
    literal_memberships = [[] for _ in range(2 * num_vars + 1)]
    for clause_index, clause in enumerate(clauses):
        for literal in clause:
            if literal == 0:
                continue
            if literal > 0:
                literal_memberships[literal].append(clause_index)
            else:  # literal < 0
                literal_memberships[abs(literal) + num_vars].append(clause_index)
    return literal_memberships

# Tested and works
def packing_algorithm(literal_memberships):
    """Simple big-small packing algorithm. Sorts one list, then uses elements of sorted list to find elements of
    another list. Then finds the smallest element, pops both, etc.

    Returns:
       packed_literal_array: an array of the form [[[literal_a, literal_b], [membership of literal_a, membership of literal_b]], ...]
       masks: a list of tuples indicating the start and end positions for each literal within the packed array (1-based indexing)
    """
    literal_memberships.pop(0)  # Remove 1-based indexing trick
    num_vars = len(literal_memberships)
    
    packed_literal_array = []
    size_unsorted_arr = [len(i) for i in literal_memberships]
    size_sorted_arr = sorted(enumerate(size_unsorted_arr), key=lambda x: x[1])

    masks = [(0, 0)] * (num_vars + 1)
    current_mask_position = 0

    while len(size_sorted_arr) > 1:
        small_index, current_size_small = size_sorted_arr.pop(0)  # get first
        small = literal_memberships[small_index]

        big_index, current_size_big = size_sorted_arr.pop()  # get last
        big = literal_memberships[big_index]

        current_pack_array = [[big_index + 1, small_index + 1], big + small]
        packed_literal_array.append(current_pack_array)

        masks[big_index + 1] = (current_mask_position, current_mask_position + len(big) - 1)
        masks[small_index + 1] = (current_mask_position + len(big), current_mask_position + len(big) + len(small) - 1)
        current_mask_position += len(big) + len(small)

    if size_sorted_arr:
        remaining_index, remaining_size = size_sorted_arr.pop()
        remaining = literal_memberships[remaining_index]
        packed_literal_array.append([[remaining_index + 1], remaining])
        masks[remaining_index + 1] = (current_mask_position, current_mask_position + len(remaining) - 1)

    return packed_literal_array, masks

def packing_algorithm_20_as_max(literal_memberships):
    """Simple big-small packing algorithm with a max pack size of 20. Sorts one list, then uses elements of sorted list to find elements of
    another list. Then finds the smallest element, pops both, etc.

    Returns:
       packed_literal_array: an array of the form [[[literal_a, literal_b], [membership of literal_a, membership of literal_b]], ...]
       masks: a list of tuples indicating the start and end positions for each literal within the packed array (1-based indexing)
    """
    literal_memberships.pop(0)  # Remove 1-based indexing trick
    num_vars = len(literal_memberships)
    
    packed_literal_array = []
    size_unsorted_arr = [len(i) for i in literal_memberships]
    size_sorted_arr = sorted(enumerate(size_unsorted_arr), key=lambda x: x[1])

    masks = [(0, 0)] * (num_vars + 1)
    current_mask_position = 0

    while len(size_sorted_arr) > 1:
        small_index, current_size_small = size_sorted_arr.pop(0)  # get first
        small = literal_memberships[small_index]

        big_index, current_size_big = size_sorted_arr.pop()  # get last
        big = literal_memberships[big_index]

        # If last is bigger than 20, raise error
        if current_size_big > 20:
            raise ValueError(f"Literal at index {big_index} has size {current_size_big}, which exceeds the maximum of 20")

        # If last is exactly 20, pack it by itself and then go to next
        if current_size_big == 20:
            big = literal_memberships[big_index]
            packed_literal_array.append([[big_index + 1], big])
            masks[big_index + 1] = (current_mask_position, current_mask_position + len(big) - 1)
            current_mask_position += len(big)
            continue

        current_pack_array = [[big_index + 1, small_index + 1], big + small]
        packed_literal_array.append(current_pack_array)

        masks[big_index + 1] = (current_mask_position, current_mask_position + len(big) - 1)
        masks[small_index + 1] = (current_mask_position + len(big), current_mask_position + len(big) + len(small) - 1)
        current_mask_position += len(big) + len(small)

    if size_sorted_arr:
        remaining_index, remaining_size = size_sorted_arr.pop()
        remaining = literal_memberships[remaining_index]
        packed_literal_array.append([[remaining_index + 1], remaining])
        masks[remaining_index + 1] = (current_mask_position, current_mask_position + len(remaining) - 1)

    return packed_literal_array, masks

def convert_to_uint32_list(packed_literal_array, masks, depth=4096):
    """
    Convert packed literal array and masks to uint32 list format.
    Args:
    packed_literal_array (list): The packed literal array.
    masks (list): The masks indicating start and end positions.
    depth (int): The depth of the uint32 array.
    Returns:
    uint32_list (list): The uint32 list representation of packed literals.

    Example:
    literal address: 0x00 (depth = 2048 * 2 -> width = 12 bits)
    literal clause table membership address: 11'b00000000001
    literal clause table mask: 20b'11111000000000000000
    Then the resulting data stored in 0th index of the array would be
    31'b00000000001_11111000000000000000 
    """
    uint32_list = [0] * depth
    
    membership_address_width = 11
    clause_mask_width = 20
    
    current_index = 0
    for pack in packed_literal_array:
        literals, memberships = pack
        for literal, membership in zip(literals, memberships):
            if current_index < depth:
                # Extract membership address (11 bits) and clause mask (20 bits)
                membership_address = literal & ((1 << membership_address_width) - 1)
                clause_mask = membership & ((1 << clause_mask_width) - 1)
                
                # Combine them with a leading zero to make it 32 bits
                combined_value = (membership_address << clause_mask_width) | clause_mask
                uint32_list[current_index] = combined_value
                current_index += 1
    
    return uint32_list