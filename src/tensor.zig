//! This structure represents a tensor: a multi-dimensional matrix
//! indexed using row-major order.
//! Check: https://eli.thegreenplace.net/2015/memory-layout-of-multi-dimensional-arrays/ for row-major-order.
//!
//! List of implemented tensor operations:
//!
//!
//! To implement:
//!    - SIMD support
//!    - Custom memory allocator
//!    - Extend to generic data type (f64...)

const std = @import("std");
const testing = std.testing;
const expect = std.testing.expect;
const Allocator = std.mem.Allocator;
const dprint = std.debug.print;

/// Multi-dimensional matrix in row-major-order.
pub const Tensor = struct {
    /// The actual matrix entries represented as
    /// a flat array of f32 regardless of the tensor dimension
    data: []f32 = undefined,

    /// Array that holds the tensor rank/dimension.
    /// For example a 2D 2x2 matrix would have shape [2,2],
    /// A 3D 2x2x2 tensor would have shape [2,2,2].
    shape: []usize = undefined,

    ///Array of usize, needed to navigate tensor in memory
    ///the k-th stride represents the jump in the memory necessary to go from one element to the next one in the k-th dimension of the Tensor. (it's the dimension of the sub-tensor when fixing one dimension.)
    ///For example for a 2x2 square matrix the shape is [row = 2, column = 2] the stride for the column is one because items of the same row (or the last dimension) are contiguous because of the row-major-order. The stride for the row is instead the product of the row's shape and the column stride.
    ///Each subsequent dimension's stride is the product of the current dimension size and the previous stride. Start from the right-most one with a stride of 1.
    strides: []usize = undefined,

    ///Memory allocator to use.
    ///Will probably implement a custom allocator.
    allocator: Allocator = undefined,

    ///Init function, creates empty tensor object
    ///data is initialized with undefined
    pub fn init(allocator: Allocator, shape: []usize) !Tensor {

        //Initialize shape array and calculate strides
        const owned_shape = try allocator.dupe(usize, shape);
        errdefer allocator.free(owned_shape);

        //Initialize strides array
        var strides = try allocator.alloc(usize, shape.len);
        errdefer allocator.free(strides);

        //Calculate strides and total tensor size
        var total_dim: usize = 1;
        var i: usize = shape.len;
        while (i > 0) {
            i -= 1;
            strides[i] = total_dim;
            total_dim *= shape[i];
        }

        //Allocate space for data
        const data: []f32 = try allocator.alloc(f32, total_dim);
        errdefer allocator.free(data);

        return Tensor{
            .data = data,
            .shape = owned_shape,
            .strides = strides,
            .allocator = allocator,
        };
    }

    ///Free memory for data,shape and strides.
    ///Must be called by the owner to free the memory when done!
    ///If not called will lead to leaked mem adrs.
    pub fn deinit(self: *Tensor) void {
        self.allocator.free(self.data);
        self.allocator.free(self.shape);
        self.allocator.free(self.strides);
    }

    ///Pretty print shape and strides
    pub fn prettyDebugPrint(self: *Tensor) void {
        dprint("Shape: ", .{});
        dprint("[", .{});
        for (self.shape, 0..) |dim, i| {
            if (i == self.shape.len - 1) {
                dprint("{}", .{dim});
            } else {
                dprint("{}, ", .{dim});
            }
        }
        dprint("]\nStrides: [", .{});
        for (self.strides, 0..) |str, i| {
            if (i == self.strides.len - 1) {
                dprint("{}", .{str});
            } else {
                dprint("{}, ", .{str});
            }
        }
        dprint("]\n", .{});
    }
};

test "tensor initialization and strides calculation" {
    const alloc = std.testing.allocator;

    var shape = [_]usize{ 3, 3, 3 };
    var tensor = try Tensor.init(alloc, &shape);
    defer tensor.deinit();

    try expect(tensor.data.len == 27);

    for (tensor.shape) |dim| {
        try expect(dim == 3);
    }

    //TODO do this better
    try expect(tensor.strides[2] == 1);
    try expect(tensor.strides[1] == 3);
    try expect(tensor.strides[0] == 9);
}
