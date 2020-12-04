#include <iostream>
class Outer
{
    class Inner
    {
    public:
        void bar()
        {
            _outer->_n = 1;
        }
        Inner(Outer* out):_outer(out){}
    private:
        Outer* _outer;
    };
public:
    Outer():_i(this){}

    void foo()
    {
        _n = 0;
        std::cout << _n << std::endl;
        _i.bar();
        std::cout << _n << std::endl;
    }
private:
    Inner _i;
    int _n;
};

int main()
{
    Outer outer;
    outer.foo();
}