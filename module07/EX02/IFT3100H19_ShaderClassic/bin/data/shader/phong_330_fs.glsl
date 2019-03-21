// IFT3100H19 ~ phong_330_fs.glsl

#version 330

// attributs interpolés à partir des valeurs en sortie du shader de sommets
in vec3 surface_position;
in vec3 surface_normal;

// attribut en sortie
out vec4 fragment_color;

// couleurs de réflexion du matériau
uniform vec3 color_ambient;
uniform vec3 color_diffuse;
uniform vec3 color_specular;

// facteur de brillance spéculaire du matériau
uniform float brightness;

// position d'une source de lumière
uniform vec3 light_position;

void main()
{
  // re-normaliser la normale après interpolation
  vec3 N = normalize(surface_normal);

  // calculer la direction de la surface vers la lumière (L)
  vec3 L = normalize(light_position - surface_position);

  // calculer le niveau de réflexion diffuse (N • L)
  float reflection_diffuse = max(dot(N, L), 0.0);

  // réflexion spéculaire par défaut
  float reflection_specular = 0.0;

  // calculer la réflexion spéculaire seulement s'il y a réflexion diffuse
  if (reflection_diffuse > 0.0)
  {
    // calculer la direction de la surface vers la caméra (V)
    vec3 V = normalize(-surface_position);

    // calculer la direction de la réflection (R) du rayon incident (-L) en fonction de la normale (N)
    vec3 R = reflect(-L, N);

    // calculer le niveau de réflexion spéculaire (R • V)
    reflection_specular = pow(max(dot(V, R), 0.0), brightness);
  }

  // calculer la couleur du fragment
  fragment_color = vec4(
    color_ambient +
    color_diffuse * reflection_diffuse +
    color_specular * reflection_specular, 1.0);
}