Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52876 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbeCMMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Mar 2018 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1evibG-00031F-G4
        for fio@vger.kernel.org; Tue, 13 Mar 2018 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180313120001.DB41D2C1D65@kernel.dk>
Date: Tue, 13 Mar 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e0b3258bde6f39ab3a9d178b56526b65e0e32a8d:

  filesetup: Initialize all members of struct fio_file (2018-03-09 21:34:44 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c4bf91427a4fd1fbdb662667307189eabacf45b5:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-12 18:13:10 -0600)

----------------------------------------------------------------
Bart Van Assche (4):
      configure: Disable lex on NetBSD
      Rename struct rb_node into struct fio_rb_node
      stat: Fix a compiler warning in __show_run_stats()
      parse: Fix two compiler warnings

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 configure    |  4 +++-
 iolog.c      |  4 ++--
 iolog.h      |  2 +-
 lib/rbtree.c | 49 +++++++++++++++++++++++++------------------------
 lib/rbtree.h | 37 +++++++++++++++++++------------------
 parse.c      |  4 ++--
 stat.c       |  5 +++--
 t/dedupe.c   |  6 +++---
 verify.c     |  2 +-
 9 files changed, 59 insertions(+), 54 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index aefd5bb..a73b61e 100755
--- a/configure
+++ b/configure
@@ -252,6 +252,8 @@ elif check_define __linux__ ; then
   targetos="Linux"
 elif check_define __OpenBSD__ ; then
   targetos='OpenBSD'
+elif check_define __NetBSD__ ; then
+  targetos='NetBSD'
 elif check_define __sun__ ; then
   targetos='SunOS'
   CFLAGS="$CFLAGS -D_REENTRANT"
@@ -280,7 +282,7 @@ fi
 # cross-compiling to one of these OSes then you'll need to specify
 # the correct CPU with the --cpu option.
 case $targetos in
-AIX|OpenBSD)
+AIX|*BSD)
   # Unless explicitly enabled, turn off lex.
   # OpenBSD will hit syntax error when enabled.
   if test -z "$disable_lex" ; then
diff --git a/iolog.c b/iolog.c
index fc3dade..7d5a136 100644
--- a/iolog.c
+++ b/iolog.c
@@ -184,7 +184,7 @@ int read_iolog_get(struct thread_data *td, struct io_u *io_u)
 void prune_io_piece_log(struct thread_data *td)
 {
 	struct io_piece *ipo;
-	struct rb_node *n;
+	struct fio_rb_node *n;
 
 	while ((n = rb_first(&td->io_hist_tree)) != NULL) {
 		ipo = rb_entry(n, struct io_piece, rb_node);
@@ -208,7 +208,7 @@ void prune_io_piece_log(struct thread_data *td)
  */
 void log_io_piece(struct thread_data *td, struct io_u *io_u)
 {
-	struct rb_node **p, *parent;
+	struct fio_rb_node **p, *parent;
 	struct io_piece *ipo, *__ipo;
 
 	ipo = malloc(sizeof(struct io_piece));
diff --git a/iolog.h b/iolog.h
index 2266617..70981f9 100644
--- a/iolog.h
+++ b/iolog.h
@@ -199,7 +199,7 @@ enum {
  */
 struct io_piece {
 	union {
-		struct rb_node rb_node;
+		struct fio_rb_node rb_node;
 		struct flist_head list;
 	};
 	struct flist_head trim_list;
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 00a5a90..6f0feae 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -22,10 +22,10 @@
 
 #include "rbtree.h"
 
-static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
+static void __rb_rotate_left(struct fio_rb_node *node, struct rb_root *root)
 {
-	struct rb_node *right = node->rb_right;
-	struct rb_node *parent = rb_parent(node);
+	struct fio_rb_node *right = node->rb_right;
+	struct fio_rb_node *parent = rb_parent(node);
 
 	if ((node->rb_right = right->rb_left))
 		rb_set_parent(right->rb_left, node);
@@ -45,10 +45,10 @@ static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 	rb_set_parent(node, right);
 }
 
-static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
+static void __rb_rotate_right(struct fio_rb_node *node, struct rb_root *root)
 {
-	struct rb_node *left = node->rb_left;
-	struct rb_node *parent = rb_parent(node);
+	struct fio_rb_node *left = node->rb_left;
+	struct fio_rb_node *parent = rb_parent(node);
 
 	if ((node->rb_left = left->rb_right))
 		rb_set_parent(left->rb_right, node);
@@ -68,9 +68,9 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
 	rb_set_parent(node, left);
 }
 
-void rb_insert_color(struct rb_node *node, struct rb_root *root)
+void rb_insert_color(struct fio_rb_node *node, struct rb_root *root)
 {
-	struct rb_node *parent, *gparent;
+	struct fio_rb_node *parent, *gparent;
 
 	while ((parent = rb_parent(node)) && rb_is_red(parent))
 	{
@@ -79,7 +79,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 		if (parent == gparent->rb_left)
 		{
 			{
-				register struct rb_node *uncle = gparent->rb_right;
+				register struct fio_rb_node *uncle = gparent->rb_right;
 				if (uncle && rb_is_red(uncle))
 				{
 					rb_set_black(uncle);
@@ -92,7 +92,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 
 			if (parent->rb_right == node)
 			{
-				register struct rb_node *tmp;
+				register struct fio_rb_node *tmp;
 				__rb_rotate_left(parent, root);
 				tmp = parent;
 				parent = node;
@@ -104,7 +104,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 			__rb_rotate_right(gparent, root);
 		} else {
 			{
-				register struct rb_node *uncle = gparent->rb_left;
+				register struct fio_rb_node *uncle = gparent->rb_left;
 				if (uncle && rb_is_red(uncle))
 				{
 					rb_set_black(uncle);
@@ -117,7 +117,7 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 
 			if (parent->rb_left == node)
 			{
-				register struct rb_node *tmp;
+				register struct fio_rb_node *tmp;
 				__rb_rotate_right(parent, root);
 				tmp = parent;
 				parent = node;
@@ -133,10 +133,11 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
 	rb_set_black(root->rb_node);
 }
 
-static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
+static void __rb_erase_color(struct fio_rb_node *node,
+			     struct fio_rb_node *parent,
 			     struct rb_root *root)
 {
-	struct rb_node *other;
+	struct fio_rb_node *other;
 
 	while ((!node || rb_is_black(node)) && node != root->rb_node)
 	{
@@ -161,7 +162,7 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			{
 				if (!other->rb_right || rb_is_black(other->rb_right))
 				{
-					struct rb_node *o_left;
+					struct fio_rb_node *o_left;
 					if ((o_left = other->rb_left))
 						rb_set_black(o_left);
 					rb_set_red(other);
@@ -198,7 +199,7 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 			{
 				if (!other->rb_left || rb_is_black(other->rb_left))
 				{
-					register struct rb_node *o_right;
+					register struct fio_rb_node *o_right;
 					if ((o_right = other->rb_right))
 						rb_set_black(o_right);
 					rb_set_red(other);
@@ -219,9 +220,9 @@ static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
 		rb_set_black(node);
 }
 
-void rb_erase(struct rb_node *node, struct rb_root *root)
+void rb_erase(struct fio_rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
+	struct fio_rb_node *child, *parent;
 	int color;
 
 	if (!node->rb_left)
@@ -230,7 +231,7 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		child = node->rb_left;
 	else
 	{
-		struct rb_node *old = node, *left;
+		struct fio_rb_node *old = node, *left;
 
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
@@ -289,9 +290,9 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 /*
  * This function returns the first node (in sort order) of the tree.
  */
-struct rb_node *rb_first(struct rb_root *root)
+struct fio_rb_node *rb_first(struct rb_root *root)
 {
-	struct rb_node	*n;
+	struct fio_rb_node	*n;
 
 	n = root->rb_node;
 	if (!n)
@@ -301,9 +302,9 @@ struct rb_node *rb_first(struct rb_root *root)
 	return n;
 }
 
-struct rb_node *rb_next(const struct rb_node *node)
+struct fio_rb_node *rb_next(const struct fio_rb_node *node)
 {
-	struct rb_node *parent;
+	struct fio_rb_node *parent;
 
 	if (RB_EMPTY_NODE(node))
 		return NULL;
@@ -316,7 +317,7 @@ struct rb_node *rb_next(const struct rb_node *node)
 		node = node->rb_right; 
 		while (node->rb_left)
 			node=node->rb_left;
-		return (struct rb_node *)node;
+		return (struct fio_rb_node *)node;
 	}
 
 	/*
diff --git a/lib/rbtree.h b/lib/rbtree.h
index f31fc56..82ab97a 100644
--- a/lib/rbtree.h
+++ b/lib/rbtree.h
@@ -34,7 +34,7 @@
 static inline struct page * rb_search_page_cache(struct inode * inode,
 						 unsigned long offset)
 {
-	struct rb_node * n = inode->i_rb_page_cache.rb_node;
+	struct fio_rb_node * n = inode->i_rb_page_cache.rb_node;
 	struct page * page;
 
 	while (n)
@@ -53,10 +53,10 @@ static inline struct page * rb_search_page_cache(struct inode * inode,
 
 static inline struct page * __rb_insert_page_cache(struct inode * inode,
 						   unsigned long offset,
-						   struct rb_node * node)
+						   struct fio_rb_node * node)
 {
-	struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
-	struct rb_node * parent = NULL;
+	struct fio_rb_node ** p = &inode->i_rb_page_cache.rb_node;
+	struct fio_rb_node * parent = NULL;
 	struct page * page;
 
 	while (*p)
@@ -79,7 +79,7 @@ static inline struct page * __rb_insert_page_cache(struct inode * inode,
 
 static inline struct page * rb_insert_page_cache(struct inode * inode,
 						 unsigned long offset,
-						 struct rb_node * node)
+						 struct fio_rb_node * node)
 {
 	struct page * ret;
 	if ((ret = __rb_insert_page_cache(inode, offset, node)))
@@ -97,34 +97,34 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 #include <stdlib.h>
 #include <inttypes.h>
 
-struct rb_node
+struct fio_rb_node
 {
 	intptr_t rb_parent_color;
 #define	RB_RED		0
 #define	RB_BLACK	1
-	struct rb_node *rb_right;
-	struct rb_node *rb_left;
+	struct fio_rb_node *rb_right;
+	struct fio_rb_node *rb_left;
 } __attribute__((aligned(sizeof(long))));
     /* The alignment might seem pointless, but allegedly CRIS needs it */
 
 struct rb_root
 {
-	struct rb_node *rb_node;
+	struct fio_rb_node *rb_node;
 };
 
 
-#define rb_parent(r)   ((struct rb_node *)((r)->rb_parent_color & ~3))
+#define rb_parent(r)   ((struct fio_rb_node *)((r)->rb_parent_color & ~3))
 #define rb_color(r)   ((r)->rb_parent_color & 1)
 #define rb_is_red(r)   (!rb_color(r))
 #define rb_is_black(r) rb_color(r)
 #define rb_set_red(r)  do { (r)->rb_parent_color &= ~1; } while (0)
 #define rb_set_black(r)  do { (r)->rb_parent_color |= 1; } while (0)
 
-static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
+static inline void rb_set_parent(struct fio_rb_node *rb, struct fio_rb_node *p)
 {
 	rb->rb_parent_color = (rb->rb_parent_color & 3) | (uintptr_t)p;
 }
-static inline void rb_set_color(struct rb_node *rb, int color)
+static inline void rb_set_color(struct fio_rb_node *rb, int color)
 {
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
@@ -136,15 +136,16 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 #define RB_EMPTY_NODE(node)	(rb_parent(node) == node)
 #define RB_CLEAR_NODE(node)	(rb_set_parent(node, node))
 
-extern void rb_insert_color(struct rb_node *, struct rb_root *);
-extern void rb_erase(struct rb_node *, struct rb_root *);
+extern void rb_insert_color(struct fio_rb_node *, struct rb_root *);
+extern void rb_erase(struct fio_rb_node *, struct rb_root *);
 
 /* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_first(struct rb_root *);
-extern struct rb_node *rb_next(const struct rb_node *);
+extern struct fio_rb_node *rb_first(struct rb_root *);
+extern struct fio_rb_node *rb_next(const struct fio_rb_node *);
 
-static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
-				struct rb_node ** rb_link)
+static inline void rb_link_node(struct fio_rb_node * node,
+				struct fio_rb_node * parent,
+				struct fio_rb_node ** rb_link)
 {
 	node->rb_parent_color = (uintptr_t)parent;
 	node->rb_left = node->rb_right = NULL;
diff --git a/parse.c b/parse.c
index a9ee1ce..fdb6611 100644
--- a/parse.c
+++ b/parse.c
@@ -172,7 +172,7 @@ static unsigned long long get_mult_time(const char *str, int len,
 
 	c = strdup(p);
 	for (i = 0; i < strlen(c); i++)
-		c[i] = tolower(c[i]);
+		c[i] = tolower((unsigned char)c[i]);
 
 	if (!strncmp("us", c, 2) || !strncmp("usec", c, 4))
 		mult = 1;
@@ -218,7 +218,7 @@ static unsigned long long __get_mult_bytes(const char *p, void *data,
 	c = strdup(p);
 
 	for (i = 0; i < strlen(c); i++) {
-		c[i] = tolower(c[i]);
+		c[i] = tolower((unsigned char)c[i]);
 		if (is_separator(c[i])) {
 			c[i] = '\0';
 			break;
diff --git a/stat.c b/stat.c
index f89913b..8a242c9 100644
--- a/stat.c
+++ b/stat.c
@@ -1860,13 +1860,14 @@ void __show_run_stats(void)
 		char time_buf[32];
 		struct timeval now;
 		unsigned long long ms_since_epoch;
+		time_t tv_sec;
 
 		gettimeofday(&now, NULL);
 		ms_since_epoch = (unsigned long long)(now.tv_sec) * 1000 +
 		                 (unsigned long long)(now.tv_usec) / 1000;
 
-		os_ctime_r((const time_t *) &now.tv_sec, time_buf,
-				sizeof(time_buf));
+		tv_sec = now.tv_sec;
+		os_ctime_r(&tv_sec, time_buf, sizeof(time_buf));
 		if (time_buf[strlen(time_buf) - 1] == '\n')
 			time_buf[strlen(time_buf) - 1] = '\0';
 
diff --git a/t/dedupe.c b/t/dedupe.c
index c3b837f..9a50821 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -49,7 +49,7 @@ struct extent {
 };
 
 struct chunk {
-	struct rb_node rb_node;
+	struct fio_rb_node rb_node;
 	uint64_t count;
 	uint32_t hash[MD5_HASH_WORDS];
 	struct flist_head extent_list[0];
@@ -194,7 +194,7 @@ static struct chunk *alloc_chunk(void)
 
 static void insert_chunk(struct item *i)
 {
-	struct rb_node **p, *parent;
+	struct fio_rb_node **p, *parent;
 	struct chunk *c;
 	int diff;
 
@@ -497,7 +497,7 @@ static void show_stat(uint64_t nextents, uint64_t nchunks)
 
 static void iter_rb_tree(uint64_t *nextents, uint64_t *nchunks)
 {
-	struct rb_node *n;
+	struct fio_rb_node *n;
 
 	*nchunks = *nextents = 0;
 
diff --git a/verify.c b/verify.c
index d070f33..17af3bb 100644
--- a/verify.c
+++ b/verify.c
@@ -1307,7 +1307,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		return 0;
 
 	if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
-		struct rb_node *n = rb_first(&td->io_hist_tree);
+		struct fio_rb_node *n = rb_first(&td->io_hist_tree);
 
 		ipo = rb_entry(n, struct io_piece, rb_node);
 
