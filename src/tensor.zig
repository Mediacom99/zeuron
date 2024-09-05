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


/// Multi-dimensional matrix in row-major-order.
pub const Tensor = struct {
    
    /// The actual matrix entries represented as
    /// a flat array of f32 regardless of the tensor dimension
    data: []f32,

    /// Array that holds the tensor rank/dimension.
    /// For example a 2D 2x2 matrix would have shape [2,2],
    /// A 3D 2x2x2 tensor would have shape [2,2,2].
    shape: []usize,

    ///Array of usize, needed to navigate tensor in memory
    ///the k-th stride represents the jump in the memory necessary to go from one element to the next one in the k-th dimension of the Tensor. (it's the dimension of the sub-tensor when fixing one dimension.)
    ///For example for a 2x2 square matrix the shape is [row = 2, column = 2] the stride for the column is one because items of the same row (or the last dimension) are contiguous because of the row-major-order. The stride for the row is instead the product of the row's shape and the column stride.
    ///Each subsequent dimension's stride is the product of the current dimension size and the previous stride. Start from the right-most one with a stride of 1.
    strides: []usize,

    ///Memory allocator to use.
    ///Will probably implement a custom allocator.
    allocator: Allocator,


    
    ///Init function, creates empty tensor object
    ///data is initialized with undefined
    pub fn init(allocator: Allocator, shape: []usize) !*Tensor {
        //Create heap space for tensor
        const tensor = try allocator.create(Tensor);
        errdefer allocator.destroy(tensor);
                       
    }

    

};

test "Tensor initialization" {
    // const alloc = std.testing.allocator;

}
