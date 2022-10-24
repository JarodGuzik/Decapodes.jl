using Artifacts
using Catlab
using Catlab.CategoricalAlgebra
using CombinatorialSpaces
using FileIO
using JSON
using GeometryBasics: Point3

abstract type AbstractMeshKey end

struct Icosphere{N, R} <: AbstractMeshKey
  n::N
  r::R
end
struct Rectangle_30x10 <: AbstractMeshKey end
struct Torus_30x10 <: AbstractMeshKey end
struct Point_Map <: AbstractMeshKey end

Icosphere(n) = Icosphere(n, 1.0)

function loadmesh(s::Icosphere)
  1 <= s.n <= 5 || error("The only icosphere divisions supported are 1-5")
  m = loadmesh_helper("UnitIcosphere$(s.n).obj")
  m[:point] .*= s.r
  return m
end

function loadmesh(s::Rectangle_30x10)
  parse_json_acset(EmbeddedDeltaSet2D{Bool, Point3{Float64}},
    read(joinpath(artifact"Rectangle_30x10", "Rectangle_30x10.json"), String))
end

function loadmesh(s::Torus_30x10)
  parse_json_acset(EmbeddedDeltaDualComplex2D{Bool, Float64, Point3{Float64}},
    read(joinpath(artifact"Torus_30x10", "Torus_30x10.json"), String))
end

function loadmesh(s::Point_Map)
  JSON.parse(read(joinpath(artifact"point_map", "point_map.json"), String))
end

#loadmesh(meshkey::AbstractMeshKey)::EmbeddedDeltaSet2D

loadmesh_helper(obj_file_name) = EmbeddedDeltaSet2D(
  joinpath(artifact"all_meshes2", obj_file_name))

loadmesh(s, subdivision=Circumcenter()) = subdivide_duals!(loadmesh(s), subdivision)