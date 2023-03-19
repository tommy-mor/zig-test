const std = @import("std");
const mach = @import("libs/mach/build.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.

    const optimize = b.standardOptimizeOption(.{});

    const app = mach.App.init(b, .{
        .name = "hello",
        .src = "src/main.zig",
        .target = target,
        .deps = &[_]std.build.ModuleDependency{},
        .optimize = optimize,
    }) catch |err| {
        std.debug.panic("Failed to initialize app: {}", .{err});
    };

    app.link(.{}) catch |err| {
        std.debug.panic("Failed to link app: {}", .{err});
    };

    app.install();

    const run_cmd = app.run() catch |err| {
        std.debug.panic("Failed to create run command: {}", .{err});
    };

    run_cmd.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(run_cmd);

}
