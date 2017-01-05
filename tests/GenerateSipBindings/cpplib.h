
#pragma once

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QMap>

#include <functional>

class FwdDecl;

class MyObject : public QObject
{
  Q_OBJECT
public:
  MyObject(QObject* parent = nullptr);

  enum LocalEnum {
    Val1 = 1,
    Val2
  };
  Q_DECLARE_FLAGS(LocalEnums, LocalEnum)

  enum {
     AnonVal1,
     AnonVal2
  };

  double unnamedParameters(int, double);

  int addThree(int input) const;
  QList<int> addThree(QList<int> input) const;

  const QString addThree(const QString& input, const QString& prefix = QStringLiteral("Default")) const;

  int findNeedle(QStringList list, QString needle, Qt::MatchFlags flags = Qt::MatchFlags(Qt::MatchStartsWith | Qt::MatchWrap)) const;

  int qtEnumTest(QFlags<Qt::MatchFlag> flags);
  int localEnumTest(QFlags<MyObject::LocalEnum> flags);

  int functionParam(std::function<int()> fn);
  int groups(unsigned int maxCount = std::numeric_limits<uint>::max()) const;

  int const_parameters(const int input, QObject* const obj = 0) const;

  int fwdDecl(const FwdDecl& f);
  int fwdDeclRef(FwdDecl& f);

  mode_t dummyFunc(QObject* parent) { return 0; }

signals:
  void publicSlotCalled();

Q_SIGNALS:
  void privateSlotCalled();
  void protectedSlotCalled();

public slots:
  void publicSlot1();

public Q_SLOTS:
  void publicSlot2();

protected slots:
  void protectedSlot1();

protected Q_SLOTS:
  void protectedSlot2();

private slots:
  void privateSlot1();

private Q_SLOTS:
  void privateSlot2();
};

class NonCopyable
{
public:
  NonCopyable();
  ~NonCopyable();

private:
  int* const mNum;
};


class NonCopyableByMacro
{
public:
  NonCopyableByMacro();

private:
  Q_DISABLE_COPY(NonCopyableByMacro)
};

Q_DECLARE_METATYPE(NonCopyableByMacro*)

class HasPrivateDefaultCtor
{
public:
private:
  HasPrivateDefaultCtor(int param = 0);
};

namespace SomeNS {

class NonCopyableInNS
{
public:
  NonCopyableInNS();
  ~NonCopyableInNS();

private:
  int* const mNum;
};

}

enum __attribute__((visibility("default"))) EnumWithAttributes {
    Foo,
    Bar = 2
};
