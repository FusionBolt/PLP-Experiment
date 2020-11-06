#include <stdio.h>
int all_blanks(char s[])
{
    int i = 0;
    while(s[i] != '\0')
    {
        if(s[i] != ' ' || s[i] != '\t' || s[i] != '\r')
        {
            return 0;
        }
    }
    return 1;
}
void consume_line(char s[])
{
    printf("consume_line");
}
int main()
{
    char line[50];
    // replace read_line with gets
    // if must use read_line, then define a function do the same thing
    while(!all_blanks(gets(line)))
    {
        consume_line(line);
    }
}