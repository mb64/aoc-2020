// vim: ts=2 sts=2 sw=2 expandtab

#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

(* ugh this is way too much work just to get a arraylist *)

macdef NULL = $extval(ptr null,"0")


(* Malloc stuff *)

absviewtype MallocToken(a:vt@ype+, l:addr, n:int)

extern praxi malloc_null {a:vt@ype} (): MallocToken(a,null,0)

extern fn reallocarray {a:t@ype}{l:addr}{n:nat}{m:nat} (
  array: array_v(a,l,n), tok: MallocToken(a,l,n)
| p: ptr l, len: size_t m, size: sizeof_t a
): [l2:addr] (array_v(a,l2,m), MallocToken(a,l2,m) | ptr l2) =
  "reallocarray"

extern fn free {a:vt@ype}{l:addr}{n:nat} (
  array: array_v(a,l,n), tok: MallocToken(a,l,n)
| ptr: ptr l): void = "free"


(* Vec stuff *)

typedef VecStorage(l:addr, len:int, cap:int) = @{
  ptr= ptr l,
  len= size_t len,
  cap= size_t cap
}
vtypedef VecVT(a:t@ype+, l:addr, len:int, cap:int) = (
  array_v(a, l, len),
  array_v(a, l+len*sizeof(a), cap-len),
  MallocToken(a, l, cap)
| VecStorage(l, len, cap)
)
vtypedef Vec(a:t@ype+, len:int) = [l:addr] [cap:int| cap >= len] VecVT(a, l, len, cap)
vtypedef Vec0(a:t@ype+) = [len:nat] Vec(a,len)

fn empty_vec{a:t@ype}(): VecVT(a,null,0,0) = (
  array_v_nil(), array_v_nil(), malloc_null()
  | @{ ptr= NULL, len= g1int2uint 0, cap= g1int2uint 0 }
)

(* array_v_snoc and array_v_unsnoc *)
prfn array_v_snoc {a:vt@ype} {l:addr} {n:nat}
  (init: array_v(a,l,n), last: a @ l+n*sizeof(a)): array_v(a,l,n+1) =
  let
    prval tail = array_v_cons(last, array_v_nil())
  in array_v_unsplit(init, tail) end

prfn array_v_unsnoc {a:vt@ype} {l:addr} {n:pos}
  (arr: array_v(a,l,n)): (array_v(a,l,n-1), a @ l+(n-1)*sizeof(a)) =
  let
    prval (init, tail) = array_v_split{a}{l}{n}{n-1}(arr)
    prval (last, nil) = array_v_uncons(tail)
    prval () = array_v_unnil(nil)
  in (init, last) end

fn {a:t@ype} vec_pop {l:addr}{n:pos}{cap:int} (v: &VecVT(a,l,n,cap)>>VecVT(a,l,n-1,cap)):<!wrt> a =
  let
    val (items, extra, tok | storage) = v
    prval (init, l) = array_v_unsnoc items
    // Why is this type annotation necessary?
    prval last = l : a @ l + (n-1)*sizeof(a)
    val ptr = ptr_add<a>(storage.ptr, storage.len - 1)
    val x = !ptr
    val () = v := (init, array_v_cons(last, extra), tok | @{
        ptr= storage.ptr,
        len= storage.len - 1,
        cap= storage.cap
      })
  in x end

// aaaa, only needed bc ATS needs to be given some complete prefix of the
// implicit arguments, so if you want the address to be inferred, you
// gotta rearrange them yourself
prfn my_array_v_split {a:vt@ype}{n:nat}{m:nat | m <= n}{l:addr} (
  pf: array_v(a,l,n)
): (array_v(a,l,m), array_v(a,l+m*sizeof(a),n-m)) =
  array_v_split(pf)

fn {a:t@ype} reserve_capacity {l:addr}{n:nat}{cap:int|cap >= n}{new_cap:nat} (
  v: &VecVT(a,l,n,cap) >> [c:nat|c >= new_cap][l2:addr] VecVT(a,l2,n,c),
  new_cap: size_t new_cap
): void =
  let
    val (items, extra, tok | @{ ptr= ptr, len= len, cap= cap}) = v
  in if cap >= new_cap then begin
    v := (items, extra, tok | @{ ptr= ptr, len= len, cap= cap})
  end else let
    val new_cap = cap + new_cap // grow size exponentially
    val (new_items, new_tok | new_ptr) = reallocarray(array_v_unsplit(items, extra), tok | ptr, new_cap, sizeof<a>)
    prval (items, extra) = my_array_v_split{a}{cap + new_cap}{n}(new_items)
    val () = v := (items, extra, new_tok | @{
        ptr= new_ptr,
        len= len,
        cap= new_cap
      })
  in () end
  end

fn {a:t@ype} vec_push_good {n:nat}{l:addr}{cap:nat|cap >= n + 1} (
  v: &VecVT(a,l,n,cap) >> VecVT(a,l,n+1,cap),
  x: a
): void =
  let
    val (items, extra, tok | @{ ptr= ptr, len= len, cap= cap}) = v
    prval (head, tail) = array_v_uncons extra
    val next_item_ptr = ptr_add<a>(ptr, len)
    val () = !next_item_ptr := x
    val () = v := (array_v_snoc(items, head), tail, tok | @{
        ptr= ptr,
        len= len + 1,
        cap= cap
      })
  in () end

fn {a:t@ype} vec_push {n:nat} (v: &Vec(a,n)>>Vec(a,n+1), x: a): void =
  let
    val (items, extra, tok | @{ ptr= ptr, len= len, cap= cap }) = v
    val () = v := (items, extra, tok | @{ ptr= ptr, len= len, cap= cap})
    val () = reserve_capacity(v, len + 1)
  in vec_push_good(v, x) end

fn {a:t@ype} vec_drop (v: Vec0(a)): void =
  let
    val (items, extra, tok | @{ ptr= ptr, len= len, cap= cap }) = v
  in free(array_v_unsplit(items, extra), tok | ptr) end


(* now the actual implementation :/ *)

%{
int ats_scanf(void *format, void *x) {
    return scanf((const char *) format, x);
}
%}

extern fun scanf {l:addr} (pf: !int @ l | format: string, value: ptr l): int = "ats_scanf"

fn read_nums(): [n:nat] Vec(int,n) =
  let
    var nums: Vec0(int) = empty_vec()
    fun loop{n:nat}(xs: &Vec(int,n) >> Vec0(int)): void =
      let
        var x: int = 0
        val res = scanf(view@x | "%d\n", addr@x)
      in if res != ~1 then (
        vec_push(xs, x);
        loop(xs))
      end
    val () = loop(nums)
  in nums end

fun solve{l:addr}{n:nat} (
  items: !array_v(int,l,n) | p: ptr l, n: size_t n
): int = if n = 0 then ~1 else
  let
    prval (head,tail) = array_v_uncons items
    val x = !p
    fun loop{l:addr}{n:nat} (
      items: !array_v(int,l,n) | x:int, p: ptr l, n: size_t n
    ):int = if n = 0 then ~1 else
      let
        prval (head,tail) = array_v_uncons items
        val y = !p
      in if x + y = 2020 then let
        prval () = items := array_v_cons (head,tail)
      in x * y end else let
        val result = loop(tail | x, ptr_add<int>(p,1), n - 1)
        prval () = items := array_v_cons (head,tail)
      in result end
      end
    val result = loop(tail | x, ptr_add<int>(p,1), n - 1)
  in if result = ~1 then
    let
      val result = solve(tail | ptr_add<int>(p,1), n - 1)
      prval () = items := array_v_cons (head,tail)
    in result end
  else
    let
      prval () = items := array_v_cons (head,tail)
    in result end
  end

implement main0 () =
  let
    val (items, extra, tok | @{ ptr= p, len= n, cap= cap }) = read_nums()
    val result = solve (items | p, n)
    val () = print result
    val () = print '\n'
    val () = vec_drop @(items, extra, tok | @{ ptr= p, len= n, cap= cap })
  in () end

////
// This also works, but uses linked lists and leaks memory

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
