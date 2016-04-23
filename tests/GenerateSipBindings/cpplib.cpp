
#include "cpplib.h"

MyObject::MyObject(QObject* parent)
  : QObject(parent)
{

}

double MyObject::unnamedParameters(int i, double d)
{
  return i * d;
}

int MyObject::addThree(int input) const
{
  return input + 3;
}

QList<int> MyObject::addThree(QList<int> input) const
{
  auto output = input;
  std::transform(output.begin(), output.end(),
      output.begin(),
      [](int in) { return in + 3; });
  return output;
}

const QString MyObject::addThree(const QString& input, const QString& prefix) const
{
  return prefix + input + QStringLiteral("Three");
}

int MyObject::findNeedle(QStringList list, QString needle, Qt::MatchFlags flags) const
{
  if (flags & Qt::MatchStartsWith) {
    auto it = std::find_if(list.begin(), list.end(), [needle](QString cand) {
      return cand.startsWith(needle);
    });
    if (it != list.end()) {
      return std::distance(list.begin(), it);
    }
    return -1;
  }
  return list.indexOf(needle);
}

int MyObject::qtEnumTest(QFlags<Qt::MatchFlag> flags)
{
  return flags;
}

int MyObject::localEnumTest(QFlags<LocalEnum> flags)
{
  return flags;
}

int MyObject::functionParam(std::function<int()> fn)
{
  return fn();
}

int MyObject::groups(unsigned int maxCount) const
{
  return maxCount;
}

class FwdDecl
{

};

int MyObject::fwdDecl(const FwdDecl&)
{
  return 42;
}

int MyObject::const_parameters(const int input, QObject* const obj) const
{
  if (obj) return input / 3;
  return input / 2;
}

NonCopyable::NonCopyable()
  : mNum(new int(42))
{

}

NonCopyable::~NonCopyable()
{
  delete mNum;
}

NonCopyableByMacro::NonCopyableByMacro()
{

}

namespace SomeNS {

NonCopyableInNS::NonCopyableInNS()
  : mNum(new int(42))
{

}

NonCopyableInNS::~NonCopyableInNS()
{
  delete mNum;
}

}

void MyObject::publicSlot1()
{
  Q_EMIT publicSlotCalled();
}

void MyObject::publicSlot2()
{
  Q_EMIT publicSlotCalled();
}

void MyObject::protectedSlot1()
{
  Q_EMIT protectedSlotCalled();
}

void MyObject::protectedSlot2()
{
  Q_EMIT protectedSlotCalled();
}

void MyObject::privateSlot1()
{
  Q_EMIT privateSlotCalled();
}

void MyObject::privateSlot2()
{
  Q_EMIT privateSlotCalled();
}
