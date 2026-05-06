# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# download models into comfyui
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors' --relative-path models/text_encoders --filename 'qwen_2.5_vl_7b_fp8_scaled.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors' --relative-path models/diffusion_models --filename 'qwen_image_fp8_e4m3fn.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image-InstantX-ControlNets/resolve/main/split_files/controlnet/Qwen-Image-InstantX-ControlNet-Inpainting.safetensors' --relative-path models/controlnet --filename 'Qwen-Image-InstantX-ControlNet-Inpainting.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors' --relative-path models/vae --filename 'qwen_image_vae.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done
RUN for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors' --relative-path models/loras --filename 'Qwen-Image-Lightning-4steps-V1.0.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; echo "model-download attempt $i failed; retrying in $((i*10))s" >&2; sleep $((i*10)); done

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/image_qwen_image_instantx_inpainting_controlnet_input_image.png' "https://cool-anteater-319.convex.cloud/api/storage/a695688d-c0df-4e34-852e-98accd719eb6"
