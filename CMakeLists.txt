cmake_minimum_required(VERSION 3.10)

include(cmake/Hunter/HunterGate.cmake)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.165.tar.gz"
    SHA1 "5a73f91df5f6109c0bb1104d0c0ee423f7bece79"
    LOCAL
)

project(GAL
    VERSION 0.1
    DESCRIPTION "Graphic Abstraction Layer - by Matt Chiasson"
)
