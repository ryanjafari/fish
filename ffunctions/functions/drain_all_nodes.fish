function drain_all_nodes --description 'Drain all nodes.'

    for node in (k get nodes -o name)
        k-drain $node
    end
end
