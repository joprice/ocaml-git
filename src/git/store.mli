(*
 * Copyright (c) 2013-2017 Thomas Gazagnaire <thomas@gazagnaire.org>
 * and Romain Calascibetta <romain.calascibetta@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** Implementation of a Git stores.

    This implementation is more complete than the memory back-end because
    firstly, Git was think to be use on a file-system. Then, because for each
    operations, we let the client to control the memory consumption.

    So we provide a more powerful API which let the user to notice aready
    allocated buffers outside this scope and process some I/O operations on
    pools. *)


  type t

  type error

  val pp_error : error Fmt.t











module Make
    (H : Digestif.S)
    (FS : S.FS)
    (Inflate : S.INFLATE)
    (Deflate : S.DEFLATE) : sig
  include
    S
      with module Hash = Hash.Make(H)
       and module Inflate = Inflate
       and module Deflate = Deflate
       and module FS = FS

  val v :
    ?dotgit:Fpath.t ->
    ?compression:int ->
    ?buffer:((buffer -> unit Lwt.t) -> unit Lwt.t) ->
    FS.t ->
    Fpath.t ->
    (t, error) result Lwt.t
  (** [create ?dotgit ?compression ?buffer fs root] creates a new store
      represented by the path [root] (default is ["."]), where the Git objects
      are located in [dotgit] (default is [root / ".git"] and when Git objects
      are compressed by the [level] (default is [4]). If [buffer] is not set,
      use a [Lwt_pool] of {!default_buffer} of size 4. [fs] is the storage
      backend state. *)
end
