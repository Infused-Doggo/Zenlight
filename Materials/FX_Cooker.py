import json
import os
import sys

def convert_json_to_fx(json_data, json_filename, output_path):
    data = json.loads(json_data)
    fx_content = "\n"
    shader_name = data["m_Shader"]["Name"]
    shader_path_id = data["m_Shader"]["m_PathID"]
    shader_type_map = {
        "miHoYo/Character/NapAvatarUI": 0,
        "miHoYo/Character/NapAvatarUITransparent": 3,
        "miHoYo/Character/NapAvatarUIEye": 1,
        "miHoYo/Character/NapAvatarUIFace": 2
    }
    shader_path_id_map = {
        -1264760374214708068: 0,
        -97646000100089233: 3,
        497480590774261793: 1,
        2497034685900247571: 2
    }
    shader_value = shader_type_map.get(shader_name, shader_path_id_map.get(shader_path_id, 0))
    if "MAT_HairShadow_UI" in json_filename:
        shader_value = 4
    
    fx_content += f"#define Shader_Type {shader_value}\n"
    fx_content += "// 0 = Basic\n// 1 = Eye\n// 2 = Face\n// 3 = Transparent\n// 4 = Hair Shadow\n\n"
    
    fx_content += "// Texture Definitions\n"
    tex_envs = data["m_SavedProperties"]["m_TexEnvs"]
    for tex_name, tex_data in tex_envs.items():
        texture_name = tex_data["m_Texture"]["Name"]
        texture_path_id = tex_data["m_Texture"]["m_PathID"]
        if texture_name and tex_name != "_MainTex":
            fx_content += f'#define {tex_name} "Maps/{texture_name}.png"\n'
        elif not texture_name and texture_path_id:
            fx_content += f'#define {tex_name} "Maps/Texture_{texture_path_id}.png"\n'
    
    fx_content += "\n"
    fx_content += "// Float Properties\n"
    float_props = data["m_SavedProperties"]["m_Floats"]
    for float_name, float_value in float_props.items():
        fx_content += f"float {float_name} = {float_value}f;\n"
    
    fx_content += "\n"
    fx_content += "// Color Properties\n"
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
            fx_file_name = os.path.splitext(base_name)[0].replace("MAT_", "") + '.fx'
            output_path = os.path.join(script_dir, fx_file_name)
            convert_json_to_fx(json_data, base_name, output_path)
            print(f'File {fx_file_name} generated.')

if __name__ == "__main__":
    main()
