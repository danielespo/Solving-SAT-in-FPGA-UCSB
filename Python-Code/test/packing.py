import parsecnf as rd
from collections import deque
# Greedy clause packing algorithms for the memory in the SAT solver
# General idea: take .cnf file and generate bitstreams to program the memory with.
# 2025 UC Santa Barbara
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

# Tested and works (summer 2024)

def packing_algorithm(literal_memberships):
    """Simple big-small packing algorithm. Sorts one list, then uses elements of sorted list to find elements of
    another list. Then finds the smallest element, pops both, etc.

    Returns:
       packed_literal_array: an array of the form [[[literal_a, literal_b], [membership of literal_a, membership of literal_b]], ...]
       masks: a list of tuples indicating the start and end positions for each literal within the packed array (1-based indexing)
    
    Changelog 01/15/2025:
    Refactored packing algorithm maintains the sorted order using a deque.
    """
    # Create a copy to avoid mutating the original list
    literal_memberships = literal_memberships.copy()
    literal_memberships.pop(0)  # Remove 1-based indexing trick
    num_vars = len(literal_memberships)
    
    # Sort literals based on the size of their membership lists in ascending order
    size_sorted_arr = sorted(enumerate([len(i) for i in literal_memberships]), key=lambda x: x[1])
    size_sorted_deque = deque(size_sorted_arr)
    
    packed_literal_array = []
    masks = [(0, 0)] * (num_vars + 1)
    current_mask_position = 0
    
    while len(size_sorted_deque) > 1:
        # Pop the smallest and largest
        small = size_sorted_deque.popleft()
        big = size_sorted_deque.pop()
        
        small_index, small_size = small
        big_index, big_size = big
        
        # Create the packed group
        current_pack_array = [
            [big_index + 1, small_index + 1],
            literal_memberships[big_index] + literal_memberships[small_index]
        ]
        packed_literal_array.append(current_pack_array)
        
        # Update masks
        masks[big_index + 1] = (current_mask_position, current_mask_position + len(literal_memberships[big_index]) - 1)
        masks[small_index + 1] = (
            current_mask_position + len(literal_memberships[big_index]),
            current_mask_position + len(literal_memberships[big_index]) + len(literal_memberships[small_index]) - 1
        )
        current_mask_position += len(literal_memberships[big_index]) + len(literal_memberships[small_index])
    
    # Handle the remaining literal, if any
    if size_sorted_deque:
        remaining = size_sorted_deque.pop()
        remaining_index, remaining_size = remaining
        packed_literal_array.append([[remaining_index + 1], literal_memberships[remaining_index]])
        masks[remaining_index + 1] = (
            current_mask_position,
            current_mask_position + len(literal_memberships[remaining_index]) - 1
        )
    
    return packed_literal_array, masks

def packing_algorithm_20_as_max(literal_memberships):
    """Simple big-small packing algorithm with a max pack size of 20. Sorts one list, then uses elements of sorted list to find elements of
    another list. Then finds the smallest element, pops both, etc.

    Returns:
       packed_literal_array: an array of the form [[[literal_a, literal_b], [membership of literal_a, membership of literal_b]], ...]
       masks: a list of tuples indicating the start and end positions for each literal within the packed array (1-based indexing)
   
    Changelog: Refactored 01/15/2025 to make deterministic via deque.
    """
   
    # Create a copy to avoid mutating the original list
    literal_memberships = literal_memberships.copy()
    literal_memberships.pop(0)  # Remove 1-based indexing trick
    num_vars = len(literal_memberships)
    
    # Sort literals based on the size of their membership lists in ascending order
    size_sorted_arr = sorted(enumerate([len(i) for i in literal_memberships]), key=lambda x: x[1])
    size_sorted_deque = deque(size_sorted_arr)
    
    packed_literal_array = []
    masks = [(0, 0)] * (num_vars + 1)
    current_mask_position = 0
    
    while len(size_sorted_deque) > 1:
        # Peek at the largest without removing
        big = size_sorted_deque[-1]
        big_index, big_size = big
        
        if big_size > 20:
            raise ValueError(f"Literal at index {big_index + 1} has size {big_size}, which exceeds the maximum of 20")
        
        if big_size == 20:
            # Pack it by itself
            big = size_sorted_deque.pop()
            packed_literal_array.append([[big_index + 1], literal_memberships[big_index]])
            masks[big_index + 1] = (
                current_mask_position,
                current_mask_position + len(literal_memberships[big_index]) - 1
            )
            current_mask_position += len(literal_memberships[big_index])
            continue
        
        # Pop the smallest
        small = size_sorted_deque.popleft()
        small_index, small_size = small
        
        # Pair with the largest
        big = size_sorted_deque.pop()
        big_index, big_size = big
        
        # Check if the combined size exceeds 20
        if big_size + small_size > 20:
            # If the smallest cannot be paired with any, pack it alone
            if small_size > 20:
                raise ValueError(f"Literal at index {small_index + 1} has size {small_size}, which exceeds the maximum of 20")
            # Re-insert the big literal and pack the small literal alone
            size_sorted_deque.appendleft(big)
            packed_literal_array.append([[small_index + 1], literal_memberships[small_index]])
            masks[small_index + 1] = (
                current_mask_position,
                current_mask_position + len(literal_memberships[small_index]) - 1
            )
            current_mask_position += len(literal_memberships[small_index])
            continue
        
        # Create the packed group
        current_pack_array = [
            [big_index + 1, small_index + 1],
            literal_memberships[big_index] + literal_memberships[small_index]
        ]
        packed_literal_array.append(current_pack_array)
        
        # Update masks
        masks[big_index + 1] = (current_mask_position, current_mask_position + len(literal_memberships[big_index]) - 1)
        masks[small_index + 1] = (
            current_mask_position + len(literal_memberships[big_index]),
            current_mask_position + len(literal_memberships[big_index]) + len(literal_memberships[small_index]) - 1
        )
        current_mask_position += len(literal_memberships[big_index]) + len(literal_memberships[small_index])
    
    # Handle the remaining literal, if any
    if size_sorted_deque:
        remaining = size_sorted_deque.pop()
        remaining_index, remaining_size = remaining
        if remaining_size > 20:
            raise ValueError(f"Literal at index {remaining_index + 1} has size {remaining_size}, which exceeds the maximum of 20")
        packed_literal_array.append([[remaining_index + 1], literal_memberships[remaining_index]])
        masks[remaining_index + 1] = (
            current_mask_position,
            current_mask_position + len(literal_memberships[remaining_index]) - 1
        )
    
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