//
//  Renderer.swift
//  ThalliumApp
//
//  Created by Saul Rodriguez on 11/30/19.
//  Copyright © 2019 Saul Rodriguez. All rights reserved.
//

// Reference https://donaldpinckney.com/metal/2018/07/05/metal-intro-1.html
import Foundation
import Metal
import MetalKit

class Renderer : NSObject, MTKViewDelegate
{
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    let vertexBuffer: MTLBuffer
    var vertexCount = 0
    // This is the initializer for the Renderer class.
    // We will need access to the mtkView later, so we add it as a parameter here.
    init?(mtkView: MTKView)
    {
        device = mtkView.device!
        commandQueue = device.makeCommandQueue()!
        
        do
        {
            pipelineState = try Renderer.buildRenderPipelineWith(device: device, metalKitView: mtkView)
        }
        catch
        {
            print("Unable to compile render pipeline state: \(error)")
            return nil
        }
        
        // Create our vertex data

        let vertices3D = [Vertex_3D(color: [0, 1, 0, 1], pos: [ 0.1,  0.1, 0.7]),
                          Vertex_3D(color: [0, 1, 0, 1], pos: [-0.1,  0.1, 0.7]),
                          Vertex_3D(color: [0, 1, 0, 1], pos: [-0.1, -0.1, 0.7]),
                          Vertex_3D(color: [0, 0, 1, 1], pos: [ 0.1,  0.1, 0.7]),
                          Vertex_3D(color: [0, 0, 1, 1], pos: [ 0.1, -0.1, 0.7]),
                          Vertex_3D(color: [0, 0, 1, 1], pos: [-0.1, -0.1, 0.7]),
        
                          Vertex_3D(color: [0.3, 0.3, 0.3, 0.3], pos: [ 0.1,  0.3, -0.4]),
                          Vertex_3D(color: [0.3, 0.3, 0.3, 0.3], pos: [-0.1,  0.3, -0.4]),
                          Vertex_3D(color: [0.3, 0.3, 0.3, 0.3], pos: [-0.1,  0.1,  0.7]),
                          Vertex_3D(color: [0.4, 0.4, 0.4, 0.4], pos: [ 0.1,  0.3, -0.4]),
                          Vertex_3D(color: [0.4, 0.4, 0.4, 0.4], pos: [ 0.1,  0.1,  0.7]),
                          Vertex_3D(color: [0.4, 0.4, 0.4, 0.4], pos: [-0.1,  0.1,  0.7])]


        vertexCount = vertices3D.count
        vertexBuffer = device.makeBuffer(bytes: vertices3D, length: vertices3D.count * MemoryLayout<Vertex_3D>.stride, options: [])!
    }
    
    // mtkView will automatically call this function
    // whenever it wants new content to be rendered.
    func draw(in view: MTKView)
    {
        // Get an available command buffer
        guard let commandBuffer = commandQueue.makeCommandBuffer()
        else
        {
            return
        }
        // Get the default MTLRenderPassDescriptor from the MTKView argument
        guard let renderPassDescriptor = view.currentRenderPassDescriptor
        else
        {
            return
        }
        // Change default settings. For example, we change the clear color from black to red.
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.7, 0.7, 0.7, 0.7)
        
        // We compile renderPassDescriptor to a MTLRenderCommandEncoder.
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        // Setup render commands to encode
        // We tell it what render pipeline to use
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // What vertex buffer data to use
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
                
        // And what to draw
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount)
        
        // This finalizes the encoding of drawing commands.
        renderEncoder.endEncoding()

        
        // Tell Metal to send the rendering result to the MTKView when rendering completes
        commandBuffer.present(view.currentDrawable!)
        
        // Finally, send the encoded command buffer to the GPU.
        commandBuffer.commit()
    }
    
    // mtkView will automatically call this function
    // whenever the size of the view changes (such as resizing the window).
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        
    }
    
    // Create our custom rendering pipeline, which loads shaders using `device`, and outputs to the format of `metalKitView`
    class func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState
    {
        // Create a new pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        // Setup the shaders in the pipeline
        let library = device.makeDefaultLibrary()
        //pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader3D")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        // Setup the output pixel format to match the pixel format of the metal kit view
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        // Compile the configured pipeline descriptor to a pipeline state object
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

