#include <iostream>
using namespace std;

struct Spy {
  // Default (empty) constructor:
  Spy():value(1) { printf(FORM, this, "Spy()"); }
  // Constructor with argument:
  Spy(int value):value(value) { printf(FORM, this, "Spy(int)"); }
  // Copy constructor:
  Spy(const Spy& s):value(s.value) { printf(FORM, this, "Spy(Spy&)"); }
  // Static factory functions:
  static Spy  createObj() { Spy spy; return spy; }
  static Spy& createRef() { Spy spy; return spy; }
  // Getters for current object:
  Spy  getObj()    { return *this; }
  Spy& getRef() { return *this; }
  // Destructor:
  ~Spy() { this->value = 0; printf(FORM, this, "destroy"); }

  int value;
  const char* FORM = "%p: %s\n";
};

int main() {
  //              Spy  spy;
  //              Spy  spy(9);
  //              Spy  spy();
  //              Spy& spy;
  //              Spy  spy = Spy;
  //              Spy  spy = Spy(9);
  //              Spy  spy = Spy();
  //              Spy& spy = Spy();
  //        const Spy& spy = Spy();
  //        const Spy& spy;
  //        const Spy& spy();
  //        const Spy& spy(9);
  //       Spy s; Spy  spy = s;
  //       Spy s; Spy& spy = s;
  // Spy s; const Spy& spy = s;
  //     Spy spy;      spy = Spy();
  //              Spy  spy = Spy::createObj();
  //              Spy& spy = Spy::createObj();
  //        const Spy& spy = Spy::createObj();
  //              Spy  spy = Spy::createRef();
  //              Spy& spy = Spy::createRef();
  //        const Spy& spy = Spy::createRef();
  //              Spy  spy = Spy().getRef();
  //              Spy& spy = Spy().getRef();
  //        const Spy& spy = Spy().getRef();
  //              Spy  spy = Spy().getObj();
  //              Spy& spy = Spy().getObj();
  //        const Spy& spy = Spy().getObj();

  cout << "value = " << spy.value << endl;
}
