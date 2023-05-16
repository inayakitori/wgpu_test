// Vertex

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) color: vec3<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) uv: vec2<f32>,
    @location(1) color: vec3<f32>,
    @location(2) world_position: vec3<f32>,
};

@vertex
fn vs_main(
    vertex: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.clip_position = vec4<f32>(vertex.position, 1.0);
    out.world_position = vertex.position;
    out.uv = vertex.uv;
    out.color = vertex.color;
    return out;
}

// Fragment

@group(0) @binding(0)
var t_diffuse: texture_2d<f32>;
@group(0) @binding(1)
var s_diffuse: sampler;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let col = vec4<f32>(0., 0., 1., 0.);
    let c = in.world_position.xy * 2.1; //function input
    var z = vec2<f32>(0.,0.);
    let num_iter = 1000;
    for(var i : i32 = 0; i < num_iter; i++){
        z = cmul(z,z) + c;
        //if outside disk |z| = 2 will definitely diverge
        if(z.x * z.x + z.y * z.y > 4.) {
            return col * 0.5 + 0.5 * (f32(i) / f32(num_iter));
        }
    }
    return vec4<f32>(z, 0., 0.);
}

fn cmul(z: vec2<f32>, w: vec2<f32>) -> vec2<f32> {
    return vec2<f32>(
        z.x * w.x - z.y * w.y,
        z.x * w.y + z.y * w.x
    );
}
