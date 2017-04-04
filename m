Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/8] Make lib/prio_tree.c a stand-alone library
Date: Tue,  4 Apr 2017 23:22:14 +0300
Message-Id: <20170404202218.52260-4-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

lib/prio_tree.c not having dependency on fio.h enables it to be
a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under lib/ directory do things this way.

--
 # cat ./test2.c
 #include <stdio.h>
 #include "lib/prio_tree.h"
 int main(void) {
         struct prio_tree_root tree;
         struct prio_tree_node node;
         INIT_PRIO_TREE_ROOT(&tree);
         INIT_PRIO_TREE_NODE(&node);
         prio_tree_insert(&tree, &node);
         prio_tree_remove(&tree, &node);
         printf("%d\n", prio_tree_empty(&tree));
         return 0;
 }
 # gcc -Wall -g -DBITS_PER_LONG=64 ./test2.c ./lib/prio_tree.c
 # ./a.out
 1

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/prio_tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index e18ae32..de3fe1c 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -13,9 +13,12 @@
 
 #include <stdlib.h>
 #include <limits.h>
-#include "../fio.h"
+
+#include "../compiler/compiler.h"
 #include "prio_tree.h"
 
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+
 /*
  * A clever mix of heap and radix trees forms a radix priority search tree (PST)
  * which is useful for storing intervals, e.g, we can consider a vma as a closed
-- 
2.9.3


