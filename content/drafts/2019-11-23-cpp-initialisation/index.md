+++
draft = true
title = "The ultimate challenge"
subtitle = "Creating objects in C++"
date = "2019-09-16"
tags = ["coding"]
image = "/posts/"
image_info = ""
id = "DcY6m"
url = "DcY6m/"
aliases = ["DcY6m"]
+++



```cpp
struct Spy {
  // Default (empty) constructor:
  Spy():value(1) { printf(FORM, this, "Spy()"); }
  // Constructor with argument:
  Spy(int value):value(value) { printf(FORM, this, "Spy(int)"); }
  // Copy constructor:
  Spy(const Spy& s):value(s.value) { printf(FORM, this, "Spy(Spy&)"); }
  // Static factory functions:
  static Spy  createObject()    { Spy spy; return spy; }
  static Spy& createReference() { Spy spy; return spy; }
  // Getters for current object:
  Spy  getObject()    { return *this; }
  Spy& getReference() { return *this; }
  // Destructor:
  ~Spy() { this->value = 0; printf(FORM, this, "destroy"); }

  int value;
  const char* FORM = "%p: %s\n";
};
```

```cpp
int main() {
  Spy spy = /* ... */;
  cout << "value = " << spy.x << endl;
}
```

Before we start, 

```cpp
Spy  spy;
Spy  spy(9);
Spy  spy();
Spy  spy = Spy;
Spy  spy = Spy(9);
Spy  spy = Spy();
Spy& spy = Spy();
Spy  spy = Spy().getReference();
Spy& spy = Spy().getReference();
Spy  spy = Spy().getObject();
Spy& spy = Spy().getObject();
Spy orig; Spy  spy = orig;
Spy orig; Spy& spy = orig;
Spy  spy;  spy = Spy();
Spy  spy = Spy::createObject();
Spy& spy = Spy::createObject();
Spy  spy = Spy::createReference();
Spy& spy = Spy::createReference();
```

### `Spy spy;`

```
0x2BD0: Spy()
value = 1
0x2BD0: destroy
```

### `Spy spy(9);`

### `Spy spy();`

This either doesn’t output anything or it yields a compile error, in case you want to access `spy.value`. In analogy to the syntax in #2 one is successfully tricked into thinking that this creates an object and calls the empty constructor. However, this statement has nothing todo with object construction – it rather is the declaration of a function of name `spy` with return type `Spy`.

### `Spy spy = Spy;`

This doesn’t compile. `Spy` is not a value and can thus not be assigned to `spy`.

### #5 `Spy spy = Spy(9);`

```
0xABD0: Spy(int)
value = 0
0xABD0: destroy
```

This effectively gets simplified to #2.

### #6 `Spy spy = Spy();`

```
0x9BD0: Spy()
value = 0
0x9BD0: destroy
```

### #7 `Spy& spy = Spy();`

This doesn’t compile. It creates an object ob

### #8 `const Spy& spy = Spy();`

```
0xBBC8: Spy()
value = 0
0xBBC8: destroy
```

Although it
