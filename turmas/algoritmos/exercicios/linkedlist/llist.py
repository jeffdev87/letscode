class Node:
    def __init__(self, val):
        self.val = val
        self.next = None


class LinkedList:
    def __init__(self):
        self.head = None


linked_list = LinkedList()
n1 = Node(10)
n2 = Node(11)

linked_list.head = n1
n1.next = n2

root = linked_list.head
while root is not None:
    print(root.val)
    root = root.next
