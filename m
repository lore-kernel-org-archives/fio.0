Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] revert/rework 81647a9a('fix load_ioengine() not to support no "external:" prefix')
Date: Fri,  1 Sep 2017 22:54:12 +0300
Message-Id: <20170901195412.119846-2-tkusumi@tuxera.com>
In-Reply-To: <20170901195412.119846-1-tkusumi@tuxera.com>
References: <20170901195412.119846-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

We have decided to revert 81647a9a, which disallowed loading an external
ioengine without using (explicitly documented)"external:" prefix.

[PATCH 4/5] fix load_ioengine() not to support no "external:" prefix
http://www.spinics.net/lists/fio/msg06241.html

> The current implementation (i.e. do 2 if 1 failed) happened to have
> been able to load an external ioengine with below syntax without
> "external:" prefix, but this is a bug rather than a feature.

This commit reverts what 81647a9a does, while keeping a commit made
on top of it. See below for details, which is also available in above
mailing list thread. Lines marked with \ are comments by Jens.

--
  >>>>>>> People have already started depending on the "wrong" behaviour e.g.
  >>>>>>> ioengine=libfio_ceph_objectstore.so # must be found in your LD_LIBRARY_PATH
  >>>>>>> from https://github.com/ceph/ceph/blob/master/src/test/fio/ceph-bluestore.fio
  >>>>>>> . Because they're external it's hard to find out just how prevalent
  >>>>>>> this behaviour is.
  >>>>>>
  >>>>>> Then they can add "external:".
  >>>>>> If it has ever been official (in docs/etc), then the program should
  >>>>>> maintain such behavior, like fio keeps kb_base=1024 by default.
  >>>>>>
  >>>>>> This isn't the first time fio broke external ioengines to begin with,
  >>>>>> and fio doesn't guarantee external ioengines.
  >>>>>> e.g. this commit more than a year ago broke ABI.
  >>>>>> 565e784df05c2529479eed8a38701a33b01894bd
  >>>>>>
  >>>>>> It's essentially the same as non mainline'd kernel modules are on
  >>>>>> their own to be uptodate with upstream.
  >>>>>
 \>>>>> No, those two are VERY different. Fio doesn't make any guarantees wrt
 \>>>>> keeping the same ABI (or API, even) for external engines. If they break,
 \>>>>> then you get to keep the pieces and glue them back together. We have
 \>>>>> the engine version number as well to guard against those kinds of
 \>>>>> changes.
 \>>>>>
 \>>>>> But we don't break job files, at least not knowingly, and definitely
 \>>>>> not just in the name of a cleanup.
  >>>>
  >>>> Yes, but you took this patch which breaks job files *wrongly* using
  >>>> external engine option syntax.
  >>>
 \>>> Right, but it's not in a release yet, so it's not impossible to just
 \>>> revert it.
  >>>
  >>>> By "job files wrongly using", I mean job files somehow found
  >>>> unofficial (i.e. undocumented, not intended) way to dlopen it.
  >>>
 \>>> This case is a bit difficult, since it isn't black and white. I took a
 \>>> look at some of the older documentation, and we have been documenting
 \>>> the need for 'external' for a long time (forever?). So I'd be inclined
 \>>> to let this one stay in.
  >>>
  >>>> If breaking this case is not okay, shouldn't this commit be reverted
  >>>> or the design be expand to allow both with/without prefix ?
  >>>
 \>>> The design (or intent, at least) has always been that if you do:
 \>>>
 \>>> ioengine=something
 \>>>
 \>>> then we first try and load 'something' as an internal engine. If that
 \>>> fails, we look for an external engine of that name. That makes sense to
 \>>> me, since it means you don't have to do anything special to load an
 \>>> external engine. I think we should try and retain that behavior, if we
 \>>> can.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index e78b4f7..fa4acab 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -143,17 +143,30 @@ static struct ioengine_ops *__load_ioengine(const char *name)
 struct ioengine_ops *load_ioengine(struct thread_data *td)
 {
 	struct ioengine_ops *ops = NULL;
-	const char *name = NULL;
+	const char *name;
 
-	if (strcmp(td->o.ioengine, "external")) {
-		name = td->o.ioengine;
-		ops = __load_ioengine(name);
-	} else if (td->o.ioengine_so_path) {
-		name = td->o.ioengine_so_path;
+	/*
+	 * Use ->ioengine_so_path if an external ioengine path is specified.
+	 * In this case, ->ioengine is "external" which also means the prefix
+	 * for external ioengines "external:" is properly used.
+	 */
+	name = td->o.ioengine_so_path ?: td->o.ioengine;
+
+	/*
+	 * Try to load ->ioengine first, and if failed try to dlopen(3) either
+	 * ->ioengine or ->ioengine_so_path.  This is redundant for an external
+	 * ioengine with prefix, and also leaves the possibility of unexpected
+	 * behavior (e.g. if the "external" ioengine exists), but we do this
+	 * so as not to break job files not using the prefix.
+	 */
+	ops = __load_ioengine(td->o.ioengine);
+	if (!ops)
 		ops = dlopen_ioengine(td, name);
-	} else
-		log_err("fio: missing external ioengine path\n");
 
+	/*
+	 * If ops is NULL, we failed to load ->ioengine, and also failed to
+	 * dlopen(3) either ->ioengine or ->ioengine_so_path as a path.
+	 */
 	if (!ops) {
 		log_err("fio: engine %s not loadable\n", name);
 		return NULL;
-- 
2.9.5


