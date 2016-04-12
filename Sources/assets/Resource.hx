package assets;
typedef Resource = {
    status: ResourceStatus,
    data: Dynamic
}

enum ResourceStatus {
    OK;
    FAIL;
}