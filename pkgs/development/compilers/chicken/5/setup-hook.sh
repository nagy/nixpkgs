addChickenRepositoryPath() {
    addToSearchPath CHICKEN_REPOSITORY_PATH "$1/lib/chicken/11"
    addToSearchPath CHICKEN_INCLUDE_PATH "$1/share"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
