interface Chooser<T> {
    public Boolean better(T a, T b);
}

class Arbiter<T> {
    T bestSoFar;
    Chooser<? super T> comp;

    public Arbiter(Chooser<? super T> c) {
        comp = c;
    }
    public void consider(T t) {
        if (bestSoFar == null || comp.better(t, bestSoFar)) bestSoFar = t;
    }
    public T best() {
        return bestSoFar;
    }
}

class CaseSensitive implements Chooser<String> {
    public Boolean better(String a, String b) {
        return a.compareTo(b) < 1;
    }
}

class CaseInsensitive implements Chooser<Object> {
    public Boolean better(Object a, Object b) {
        return a.toString().compareToIgnoreCase(b.toString()) < 1;
    }
}

class Test<T> {
    Chooser<? extends T> comp;
    public Test(Chooser<? extends T> c) {
        comp = c;
    }
}
public class main {
    public static void main(String args[]) {
        Test<String> strs = new Test<String>(new CaseSensitive());
        // <? extends T>
        // error, because of Object is not extends String
        // Test<String> str = new Test<String>(new CaseInsensitive());
        Test<Object> objs = new Test<Object>(new CaseSensitive());
        Test<Object> obj = new Test<Object>(new CaseInsensitive());

        Arbiter<String> csNames = new Arbiter<String>(new CaseSensitive());
        csNames.consider(new String("Apple"));
        csNames.consider(new String("aardvark"));
        System.out.println(csNames.best());         // Apple

        Arbiter<String> ciNames = new Arbiter<String>(new CaseInsensitive());
        ciNames.consider(new String("Apple"));
        ciNames.consider(new String("aardvark"));
        System.out.println(ciNames.best());         // aardvark
    }
}
