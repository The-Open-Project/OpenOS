# Naming conventions in OpenOS source code

**Reminder**: use descriptive names when naming an object. This will allow others to understand the code.

**Note**: the standard library is excluded from these rules.

## Constants

For constants, whether static or not, use the format: `<SCREAMING_CASE_NAME>`.

## Global variables

### Extern and static

#### **In translation units**

For extern or static global variables declared in translation units, use the format: `_<camelCaseName>`.

#### **In header files**

For extern or static global variables declared in translation units, use the format: `<camelCaseName>`.

## Local variables

For local variables, use the format: `<camelCaseName>`.

## Private member variables and constants

For **private** member variables and constants inside structs and classes, use the format: `m_<snake_case_name>`.

## Functions

## Global functions in assembly code

In assembly, use `_<snake_case_name>` for naming global functions visible to C code, but not meant to be used by the user.

### Static functions

For static functions **in translation units**, use the format: `__<camelCaseName>`. Otherwise, if defined in a class, struct, or header file, refer to the rule below.

### Non-static functions and public member functions

For normal, non-static functions, use the format: `<camelCaseName>`.

### Private member functions

For private member functions declared or defined inside classes or structs, use the format: `_<camelCaseName>`.

## Everything else

Use the format: `<camelCaseName>` for everything else.

## Classes and structs

For classes and structs, use: `<PascalCaseName>`.

## Macros

For macros, use:
`_<SCREAMING_CASE_NAME>` for macros defined in translation units
**or**
`<SCREAMING_CASE_NAME>` for macros in header files.

## Example

```c++
#include <iostream>

#define _QUUX 10

static void *_global_bar;

class BarClass
{
public:
    int getX();
    void setX(int newX);
private:
    void _jellyFunction();
    int m_x;
};

static void __printQuux()
{
    std::cout << _QUUX;
}

int main(int argc, char *argv[])
{
    char foo = 'c';
    const int BAZ = 10;
    BarClass bar;
    bar.setX(10);

    __printQuux();
    std::cout << bar.getX();
}
```
