const std = @import("std");
const assert = @import("std").debug.assert;
const print = @import("std").debug.print;

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

    pub fn insert_after(self: *List, new_node: *Node, pos: u32) !void {
        var base_case = self.head.?;
        for (0..self.length) |index| {
            if (index == pos - 1) {
                var far_node = base_case.next.?;
                base_case.next = new_node;
                new_node.previous = base_case;
                new_node.next = far_node;
                far_node.previous = new_node;
                break;
            }
            base_case = base_case.next.?;
            self.length += 1;   
        }
    }
    
    pub fn get_ptr_at(self: *List, pos: u32) ?*Node {
        var base_case = self.head orelse return null;
        for (0..self.length) |index| {
            if (index == pos - 1) {
                return &base_case;
            }
            base_case = base_case.next orelse return null;

        }
    }
    pub fn delete_at(self: *List, pos: u32) !void {
        var base_case = self.head.?;
        for (0..self.length) |index| {
            if (index == pos - 2 and index + 2 < self.length) {
                var two_forward = base_case.next.?.next.?;
                base_case.next  = two_forward;
                two_forward.previous = base_case;
                break;
            }
            base_case = base_case.next.?;
            self.length -= 1;
        }
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
