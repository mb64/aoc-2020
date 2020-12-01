// vim: ts=2 sts=2 sw=2 expandtab

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

%{
int ats_scanf(void *format, void *x) {
    return scanf((const char *) format, x);
}
%}

extern fun scanf {l:addr} (pf: !int @ l | format: string, value: ptr l): int = "ats_scanf"

datatype Nums =
  | Nil
  | Cons of (int, Nums)

fun read_nums(nums: Nums): Nums =
  let
    var x: int = 0
    val res = scanf(view@x | "%d\n", addr@x)
  in
    if res = ~1
    then nums
    else read_nums(Cons(x, nums))
  end

fun go(nums: Nums): int =
  case+ nums of
  | Nil() => ~1
  | Cons(h,t) => let val res = loop (h,t) in if res = ~1 then go(t) else res end
  where {
  fun loop (x:int, l:Nums): int =
    case+ l of
    | Nil() => ~1
    | Cons(h,t) => if h + x = 2020 then h * x else loop(x,t)
  }

implement main0 () = print (go(read_nums(Nil)))
