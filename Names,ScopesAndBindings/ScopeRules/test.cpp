#include <iostream>
#include <string>
#include <functional>

std::function<void(void)> lexical_scope()
{
    std::string s = "str";
    return [=](){ // if capture val by reference, s will be dangling reference
        std::cout << s << std::endl;
        };
}
std::string out_string = "out_string";
void scope_nest()
{
    std::cout << out_string << std::endl;
}
void scope_after_declaration()
{
    // int b = a + 1;
    // Use of undeclared identifier 'a'
    int a = 1;
}

struct A;
struct B
{
    B()
    {

    }
    void set_a(A* a)
    {
        _a = a;
    }
    A* _a;
    int b = 2;
};
struct A
{
    A()
    {
        _b = new B();
        _b->set_a(this);
    }
    B* _b;
    int a = 1;
};
void types_mutually_recursive()
{
    A a;
    std::cout << "a.a is:" << a.a << std::endl;
    auto b = a._b;
    std::cout << "b.b is:" << b->b << std::endl;
}

void f1(bool run = true);
void f2(bool run = true)
{
    std::cout << "call f2" << std::endl;
    if(run)
    {
        f1(false);
    }
    
}
void f1(bool run)
{
    std::cout << "call f1" << std::endl;
    if(run)
    {
        f2(false);
    }    
}
void subroutines_mutually_recursice()
{
    f1();
}
void subroutines_class_and_bound_times()
{
    // subroutines is first-class values
    // store in variable
    // pass by value
    auto lambda = [](auto fun){ return fun; };
    // return from function
    auto return_lambda = lambda([](){
        std::cout << "in subroutines_class_and_bound_times" << std::endl;
        });
    // bind in compile
}
int main()
{
    std::string s = "str";
    auto scope_f = lexical_scope();
    scope_f();
    scope_nest();
    types_mutually_recursive();
    types_mutually_recursive();
    subroutines_mutually_recursice();
}