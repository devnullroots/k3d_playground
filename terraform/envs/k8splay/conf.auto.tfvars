project_name = "k8splay"
network = {
    vpc = {
        cidr = "10.0.0.0/16"
        vlsm_newbits = 8
        subnets = {
            private = {
                replicas = 0
            }
            public = {
                replicas = 1
            }
            isolated = {
                replicas = 0
            }
        }
    }
}
k8s = {
    control_plane = 1
    workers = 2
}