from blist import sortedlist

my_list = sortedlist([3,7,2,1])
my_list.add(5)
assert my_list[3] == 5
