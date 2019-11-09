require 'set'

class Tree
    attr_accessor :semester
    attr_accessor :cod
    attr_accessor :children
end

def get_array_children(length)
    array_hijos = []
    for i in 0..length-1
        array_hijos[i] = Tree.new
    end
    return array_hijos
end

def get_array_combi(ramos_faltantes)
    array_combi = []
    for i in 1..ramos_faltantes.length()
        array_combi.append(ramos_faltantes.combination(i).to_a)
    end
    return array_combi.flatten(1)
end

def combi(ramos, ramos_considerados, ramo_actual)
    ramos_considerados2 = ramos_considerados.dup().append(ramo_actual).flatten
    ramos_faltantes = (ramos.to_set - ramos_considerados2.to_set).to_a
    array_combi = get_array_combi(ramos_faltantes)

    t = Tree.new
    t.cod = ramo_actual
    t.children = get_array_children( array_combi.length() )
    
    for i in 0..t.children.length()-1
        t.children[i] = combi(ramos, ramos_considerados2.dup(), array_combi[i])
    end

    return t

end

def combinaciones(ramos)
    arbol = combi(ramos, [], [])
    return arbol
end


arbol = combinaciones(1..5)

