const std = @import("std");
const Tensor = @import("tensor.zig").Tensor;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var shape = [_]usize{ 2, 3, 4, 7 };
    var tensor = try Tensor.init(alloc, &shape);
    defer tensor.deinit();

    tensor.prettyDebugPrint();
    std.debug.print("Total tensor size: {}\n", .{tensor.data.len});
}
