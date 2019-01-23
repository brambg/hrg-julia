#=
hw:
- Julia version: 1.1.0
- Author: bramb
- Date: 2019-01-23
=#
const Node = Any

struct HyperEdge
    label::String
    source::Array{Node}
    target::Array{Node}
end

const HyperGraph = Array{HyperEdge}

function to_dot(he::HyperEdge)
    source = ""
    source_vars = String[]
    for (i,s) in enumerate(he.source)
        line = """
        s$i[shape=circle;width=0.05;label="";xlabel="$s";fontsize=10]
        """
        source = source * line
        push!(source_vars,"s$i")
    end
    sv = join(source_vars,",")

    target = ""
    target_vars = String[]
    for (i,t) in enumerate(he.target)
        line = """
        t$i[shape=circle;width=0.05;label="";xlabel="$t";fontsize=10]
        """
        target = target * line
        push!(target_vars,"t$i")
    end
    tv = join(target_vars,",")

    dot = """
    digraph HyperEdge {
    rankdir=LR
    labelloc=b
    color=white
    $source
    he[shape=box;label="$(he.label)"]
    $target
    {$sv} -> he -> {$tv} [arrowsize=0.5]
    }
    """
    return dot
end

function to_dot(hg::HyperGraph)
    hyperedges = ""
    node_vars = Dict{Node,String}()
    node_set = Set()
    for (i,he) in enumerate(hg)
        for s in he.source
            push!(node_set,s)
        end
        for t in he.target
            push!(node_set,t)
        end
        line = """
        he$i[shape=box;label="$(he.label)"]
        """
        hyperedges = hyperedges * line
    end

    nodes = ""
    for (i,n) in enumerate(sort(collect(node_set)))
        var = "n$i"
        node_vars[n] = var
        line = """
        $var[shape=circle;width=0.05;label="";xlabel="$n";fontsize=10]
        """
        nodes = nodes * line
    end

    edges = ""
    for (i,he) in enumerate(hg)
        source_vars = [node_vars[s] for s in he.source]
        sv = join(source_vars,",")

        target_vars = [node_vars[t] for t in he.target]
        tv = join(target_vars,",")

        line = """
        {$sv} -> he$i -> {$tv} [arrowsize=0.5]
        """
        edges = edges * line
    end

    dot = """
    digraph HyperGraph {
    rankdir=LR
    labelloc=b
    color=white

    // nodes
    $nodes
    // hyper-edges
    $hyperedges
    // edges
    $edges
    }
    """
    return dot
end

function main()
    he1 = HyperEdge("S", ["1"], ["2"])
    he2 = HyperEdge("X", ["1", "3"], ["2", "4"])
    he3 = HyperEdge("Y", ["2", "4"], ["5"])
    he4 = HyperEdge("Z", ["5"], ["6", "7", "8"])
    hg = HyperEdge[]
    map(he -> push!(hg,he), [he1, he2, he3, he4])

    he_dot = to_dot(he1)
    println(he_dot)

    he_dot = to_dot(he2)
    println(he_dot)

    hg_dot = to_dot(hg)
    println(hg_dot)
end

main()