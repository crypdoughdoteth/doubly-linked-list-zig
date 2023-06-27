const std = @import("std");
const assert = @import("std").debug.assert;
const print = @import("std").debug.print;

const ListError = error {
    EndOfList,
    EmptyList,
};

const List = struct {
    length: u32,
    head: ?*Node,
    tail: ?*Node,

    pub fn new() List {
        return List {
            .length = 0,
            .head = null,
            .tail = null,
        };
    }

    pub fn get_head_ptr(self: List) !*Node {
        return &self.head.?;
    }
    pub fn get_tail_ptr(self: List) !*Node {
        return &self.tail.?;
    }
    
    pub fn append(self: *List, new_node: *Node) void {
        if (self.tail) |tail| {
            new_node.previous = self.tail; 
            tail.next = new_node;
        }
        if (self.head == null) {
            self.head = new_node;
        } 
        self.tail = new_node; 
        self.length +=1; 
    }   


    pub fn prepend(self: *List, new_node: *Node) void {

        if (self.head) |head| {
            head.previous = new_node; 
            new_node.next = self.head;
        }        
        if (self.tail == null) {
            self.tail = new_node;
        }
        self.head = new_node; 
        self.length +=1; 
    }

    pub fn insert_after(self: *List, new_node: *Node, pos: u32) void {
        if (pos > self.length) {
            self.append(new_node);
            return;
        }
        
        if (self.head) |head| {
            var base_case = head; 
            for (0..self.length) |index| {
                if (index == pos) {
                    if (base_case.next) |next| {
                        var far_node = next.next; 
                        base_case.next = new_node;
                        new_node.previous = base_case;
                        if (far_node) |far| {
                            new_node.next = far;
                            far.previous = new_node; 
                        }
                        break;
                    }
                }
                if (base_case.next) |base| {
                    base_case = base;
                }         
            }
        } else {
            self.append(new_node);
            return;
        }
        self.length += 1; 
    }
    
    pub fn get_ptr_at(self: List, pos: u32) ?*Node {
        
        if (self.head) |head| {
            var base_case = head; 
            for (0..self.length) |index| {
                if (index == pos) {
                    return base_case;
                }
                if (base_case.next) |base| {
                    base_case = base;
                }                
            }
            return base_case;
        } 
        return null;
    }
    pub fn delete_at(self: *List, pos: u32) !void {
        if (self.head) |head| {
            var base_case = head; 
            for (0..self.length) |index| {
                if (index == pos - 1 and index + 2 < self.length) {
                    if (base_case.next) |del_node| {
                        print("{}",.{del_node.value});
                        if (del_node.next) |n2| {
                            base_case.next = n2;
                            n2.previous = base_case;
                        }
                    }
                    break;
                }
                if (base_case.next) |base| {
                    base_case = base;
                } else {
                    return ListError.EndOfList; 
                }
            } else {
                return ListError.EmptyList;
            }
        }
        self.length -= 1;

    }

    pub fn pop_front(self: *List) ?*Node {
        var old_head: ?*Node = self.head;
        
        if (self.head) |head| {
            if (head.next) |next| {
                self.head = next;
            }
        }
        self.length -=1; 
        return old_head; 
    }
    
    pub fn pop_back(self: *List) ?*Node {
        var old_tail: ?*Node = self.tail;
        
        if (self.tail) |tail| {
            if (tail.previous) |prev| {
                self.tail = prev;
            }
        }
        self.length -=1; 
        return old_tail; 
    }
    
    pub fn print_all(self: List) void {
        if (self.head) |head| {
            var base_case = head; 
            for (0..self.length + 1) |index| {
                print("\n{}, {}\n", .{base_case.value, index});
                if (base_case.next) |next| {
                    base_case = next; 
                } else {
                    return;
                }               
            }
        } 
    }
};

const Node = struct {
    value: u32,
    previous: ?*Node,
    next: ?*Node,

    pub fn new(val: u32) Node {
        return Node {
            .value = val,
            .previous = null,
            .next = null,
        };
    }
    pub fn next(self: Node) ?Node {
        var next_node = self.next orelse null;
        return next_node;
    }

    pub fn previous(self: Node) ?Node {
        var previous_node = self.previous orelse null; 
        return previous_node;
    
    }

};


pub fn main() !void {
    print("sup", .{});
}

test "Append" {
    var my_list = List.new();
    var new_node = Node.new(420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(69420);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    print("\n\n{}\n", .{my_list.head.?});
    print("\n{}\n\n", .{my_list.tail.?});
    const head = my_list.head orelse return; 
    const middle_val = head.next orelse return; 
    const tail = middle_val.next orelse return;
    assert(head == middle_val.previous);
    assert(head.next == middle_val);
    assert(middle_val.next  == tail);
    assert(tail.previous == middle_val);
}

test "Prepend" {
    var my_list = List.new();
    var new_node = Node.new(420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(69420);
    my_list.prepend(&new_node);
    my_list.prepend(&node_2);
    my_list.prepend(&node_3);
    print("\n\n{}\n", .{my_list.head.?});
    print("\n{}\n\n", .{my_list.tail.?});
    const head = my_list.head orelse return; 
    const middle_val = head.next orelse return; 
    const tail = middle_val.next orelse return;
    assert(head == middle_val.previous);
    assert(head.next == middle_val);
    assert(middle_val.next  == tail);
    assert(tail.previous == middle_val);
}

test "pop_front" {
    var my_list = List.new();
    var new_node = Node.new(420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(69420);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    assert( my_list.pop_front().?.value  == 420);
    assert( my_list.pop_front().?.value  == 24);
    assert( my_list.pop_front().?.value  == 69420);
}

test "pop_back" {
    var my_list = List.new();
    var new_node = Node.new(69420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(420);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    assert( my_list.pop_back().?.value == 420);
    assert( my_list.pop_back().?.value == 24);
    assert( my_list.pop_back().?.value == 69420);
}

test "get pointer at" {
    var my_list = List.new();
    var new_node = Node.new(69420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(420);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    print("\n\n{}\n", .{my_list.get_ptr_at(1).?});
    assert(my_list.get_ptr_at(1).? == my_list.head.?.next.?);
}

test "Insert After" {
    var my_list = List.new();
    var new_node = Node.new(420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(69420);
    var node_4 = Node.new(333);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    my_list.insert_after(&node_4, 0);
    assert(my_list.head.?.next.? == &node_4);
}

test "Delete at" {
    var my_list = List.new();
    var new_node = Node.new(420);
    var node_2 = Node.new(24);
    var node_3 = Node.new(69420);
    var node_4 = Node.new(123);
    var node_5 = Node.new(321);
    my_list.append(&new_node);
    my_list.append(&node_2);
    my_list.append(&node_3);
    my_list.append(&node_4);
    my_list.append(&node_5);
    try my_list.delete_at(3);
    my_list.print_all();
}
