# Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

# An input string is valid if:

# Open brackets must be closed by the same type of brackets.
# Open brackets must be closed in the correct order.
# Every close bracket has a corresponding open bracket of the same type.

# Example 1:
# Input: s = "()"
# Output: true

# Example 2:
# Input: s = "()[]{}"
# Output: true

# Example 3:
# Input: s = "(]"
# Output: false

# Example 4:
# Input: s = "([])"
# Output: true

# Example 5:
# Input: s = "([)]"
# Output: false

# Constraints:
# 1 <= s.length <= 104
# s consists of parentheses only '()[]{}'.

# 20. Valid Parentheses
# https://leetcode.com/problems/valid-parentheses/solutions/8601989/20-valid-parentheses-by-ssujbimv73-vdy0

REVERSE_SYMBOL = {
    "}": "{",
    ")": "(",
    "]": "["
}

class Solution:
    def isValid(self, s: str) -> bool:
        if len(s) % 2 != 0:
            return False
        
        items = []
        for item in s:
            if not items:
                items.append(item)
                continue
            
            if item in "({[":
                items.append(item)
                continue
            
            if item in ")}]":
                last_item = items.pop()
                if last_item != REVERSE_SYMBOL[item]:
                    return False
        
        if items:
            return False
        return True
