import json
import os
import sys

def convert_json_to_fx(json_data, output_path):
    data = json.loads(json_data)
    
    fx_content = "\n"
    shader_name = data["m_Shader"]["Name"]
    shader_type = {
        "miHoYo/Character/NapAvatarUI": 0,
        "miHoYo/Character/NapAvatarUIEye": 1,
        "miHoYo/Character/NapAvatarUIFace": 2,
        "miHoYo/Character/NapAvatarUITransparent": 3
    }
    shader_value = shader_type.get(shader_name, 0)
    fx_content += f"#define Shader_Type {shader_value}\n"
    fx_content += "// 0 = Basic\n// 1 = Eye\n// 2 = Face\n// 3 = Transparent\n\n"
    
    tex_envs = data["m_SavedProperties"]["m_TexEnvs"]
    for tex_name, tex_data in tex_envs.items():
        texture_name = tex_data["m_Texture"]["Name"]
        if texture_name and tex_name != "_MainTex":
            fx_content += f'#define {tex_name} "Maps/{texture_name}.png"\n'
    
    fx_content += "\n"
    float_props = data["m_SavedProperties"]["m_Floats"]
    for float_name, float_value in float_props.items():
        fx_content += f"float {float_name} = {float_value}f;\n"
    
    fx_content += "\n"
    color_props = data["m_SavedProperties"]["m_Colors"]
    for color_name, color_value in color_props.items():
        r, g, b, a = color_value["r"], color_value["g"], color_value["b"], color_value["a"]
        fx_content += f"float4 {color_name} = {{ {r}, {g}, {b}, {a} }};\n"
    
    fx_content += "\n"
    fx_content += '#include "Header.fxh"\n'

    with open(output_path, 'w') as fx_file:
        fx_file.write(fx_content)

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))

    for json_file in sys.argv[1:]:
        if json_file.endswith('.json'):
            with open(json_file, 'r') as file:
                json_data = file.read()
            base_name = os.path.basename(json_file)
            fx_file_name = os.path.splitext(base_name)[0] + '.fx'
            output_path = os.path.join(script_dir, fx_file_name)
            convert_json_to_fx(json_data, output_path)
            print(f'File {fx_file_name} generated.')

if __name__ == "__main__":
    main()
