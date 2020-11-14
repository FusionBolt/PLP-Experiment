#include <iostream>

template <typename T>
class BinTree
{
private:
    class iterator
    {
    public:
        iterator(BinTree* tree = nullptr):_curNode(tree) {}

        bool operator==(const iterator &other) const
        {
            return _curNode == other._curNode;
        }

        bool operator!=(const iterator &other) const
        {
            return !operator==(other);
        }

        BinTree* FindNextNode(BinTree* root)
        {
            if(root->_left != nullptr)
            {
                return root->_left;
            }
            else if(root->_right != nullptr)
            {
                return root->_right;
            }
            else
            {
                BinTree* parent;
                while(true)
                {
                    parent = root->_parent;
                    if(parent == nullptr)
                    {
                        return nullptr;
                    }
                    if (root == parent->_left)
                    {
                        if(parent->_right == nullptr)
                        {
                            root = parent;
                        }
                        else
                        {
                            return parent->_right;
                        }
                    }
                    else if(root == parent->_right)
                    {
                        root = parent;
                    }
                }
            }
        }
        iterator operator++()
        {
            return _curNode = FindNextNode(_curNode);
        }

        T& operator*()
        {
            return _curNode->_val;
        }

    private:
        BinTree* _curNode;
    };
public:
    BinTree(T val, BinTree* left = nullptr, BinTree* right = nullptr):
    _val(val), _left(left), _right(right){
        if(_left != nullptr)
        {
            _left->_parent = this;
        }
        if(_right != nullptr)
        {
            _right->_parent = this;
        }
    }

    iterator begin() noexcept { return iterator(this); }

    iterator end() noexcept { return iterator(); }

private:
    T _val;
    BinTree* _parent;
    BinTree* _left;
    BinTree* _right;
};

int main()
{
    BinTree tree(1,
            new BinTree(2,
                    new BinTree(3,
                            new BinTree(4)),
                    new BinTree(5)),
            new BinTree(6,
                    new BinTree(7),
                    new BinTree(8,
                            new BinTree(9),
                            new BinTree(10))));

    for (auto val : tree)
    {
        std::cout << val << std::endl;
    }
}