import pytest
import packing as pck

def test_packing_algorithm_normal_case():
    input_data = [[], [1, 2], [3, 4, 5], [6, 7], [8, 9, 10, 11]]
    expected_output = (
        [[[4, 1], [8, 9, 10, 11, 1, 2]], [[2, 3], [3, 4, 5, 6, 7]]],
        [(0, 0), (4, 5), (6, 8), (9, 10), (0, 3)]
    )
    actual_output = pck.packing_algorithm(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_empty_input():
    input_data = [[]]
    expected_output = ([], [(0, 0)])
    actual_output = pck.packing_algorithm(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_single_element():
    input_data = [[], [1, 2, 3]]
    expected_output = (
        [[[1], [1, 2, 3]]],
        [(0, 0), (0, 2)]
    )
    actual_output = pck.packing_algorithm(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_max_size_20():
    input_data = [[], [1]*20, [2, 3], [4, 5]]
    expected_output = (
        [[[1], [1]*20], [[3, 2], [4, 5, 2, 3]]],
        [(0, 0), (0, 19), (22, 23), (20, 21)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_exceeds_max_size():
    input_data = [[], [1]*21, [2, 3]]
    with pytest.raises(ValueError) as exc_info:
        pck.packing_algorithm_20_as_max(input_data)
    assert "exceeds the maximum of 20" in str(exc_info.value)

def test_packing_algorithm_all_elements_packed_separately():
    input_data = [[], [1]*20, [2]*20, [3]*20]
    expected_output = (
        [[[3], [3]*20], [[2], [2]*20], [[1], [1]*20]],
        [(0, 0), (40, 59), (20, 39), (0, 19)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

# Tests for pck.packing_algorithm_20_as_max
def test_packing_algorithm_20_as_max_normal_case():
    input_data = [[], [1, 2], [3, 4, 5], [6, 7], [8, 9, 10, 11]]
    expected_output = (
        [[[4, 1], [8, 9, 10, 11, 1, 2]], [[2, 3], [3, 4, 5, 6, 7]]],
        [(0, 0), (4, 5), (6, 8), (9, 10), (0, 3)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_20_as_max_empty_input():
    input_data = [[]]
    expected_output = ([], [(0, 0)])
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_20_as_max_single_element():
    input_data = [[], [1, 2, 3]]
    expected_output = (
        [[[1], [1, 2, 3]]],
        [(0, 0), (0, 2)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_20_as_max_max_size_20():
    input_data = [[], [1]*20, [2, 3], [4, 5]]
    expected_output = (
        [[[1], [1]*20], [[3, 2], [4, 5, 2, 3]]],
        [(0, 0), (0, 19), (22, 23), (20, 21)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"

def test_packing_algorithm_20_as_max_exceeds_max_size():
    input_data = [[], [1]*21, [2, 3]]
    with pytest.raises(ValueError) as exc_info:
        pck.packing_algorithm_20_as_max(input_data)
    assert "exceeds the maximum of 20" in str(exc_info.value)

def test_packing_algorithm_20_as_max_all_elements_packed_separately():
    input_data = [[], [1]*20, [2]*20, [3]*20]
    expected_output = (
        [[[3], [3]*20], [[2], [2]*20], [[1], [1]*20]],
        [(0, 0), (40, 59), (20, 39), (0, 19)]
    )
    actual_output = pck.packing_algorithm_20_as_max(input_data)
    assert actual_output == expected_output, f"Expected {expected_output}, but got {actual_output}"
