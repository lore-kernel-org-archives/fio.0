Return-Path: <prvs=873f0fbe3=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 05/11] options: make parsing functions available to
 ioengines
Date: Fri, 3 Sep 2021 15:20:23 +0000
Message-ID: <20210903152012.18035-6-Niklas.Cassel@wdc.com>
References: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20210903152012.18035-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Damien Le Moal <damien.lemoal@wdc.com>

Move the declaration of split_parse_ddir(), str_split_parse() and
the split_parse_fn typedef to thread_options.h so that IO engines
can use these functions to parse options. The definition of struct
split is also moved to thread_options.h from options.c.

The type of the split_parse_fn callback function is changed to add a
void * argument that can be used for an option parsing callback to pass
a private data pointer to the split_parse_fn function. This can be used
by an IO engine to pass a pointer to its engine specific option
structure as td->eo is not yet set when options are being parsed.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 options.c        | 40 ++++++++++++++++------------------------
 thread_options.h | 15 +++++++++++++++
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/options.c b/options.c
index 8c2ab7cc..708f3703 100644
--- a/options.c
+++ b/options.c
@@ -73,13 +73,7 @@ static int bs_cmp(const void *p1, const void *p2)
 	return (int) bsp1->perc - (int) bsp2->perc;
 }
=20
-struct split {
-	unsigned int nr;
-	unsigned long long val1[ZONESPLIT_MAX];
-	unsigned long long val2[ZONESPLIT_MAX];
-};
-
-static int split_parse_ddir(struct thread_options *o, struct split *split,
+int split_parse_ddir(struct thread_options *o, struct split *split,
 			    char *str, bool absolute, unsigned int max_splits)
 {
 	unsigned long long perc;
@@ -138,8 +132,8 @@ static int split_parse_ddir(struct thread_options *o, s=
truct split *split,
 	return 0;
 }
=20
-static int bssplit_ddir(struct thread_options *o, enum fio_ddir ddir, char=
 *str,
-			bool data)
+static int bssplit_ddir(struct thread_options *o, void *eo,
+			enum fio_ddir ddir, char *str, bool data)
 {
 	unsigned int i, perc, perc_missing;
 	unsigned long long max_bs, min_bs;
@@ -211,10 +205,8 @@ static int bssplit_ddir(struct thread_options *o, enum=
 fio_ddir ddir, char *str,
 	return 0;
 }
=20
-typedef int (split_parse_fn)(struct thread_options *, enum fio_ddir, char =
*, bool);
-
-static int str_split_parse(struct thread_data *td, char *str,
-			   split_parse_fn *fn, bool data)
+int str_split_parse(struct thread_data *td, char *str,
+		    split_parse_fn *fn, void *eo, bool data)
 {
 	char *odir, *ddir;
 	int ret =3D 0;
@@ -223,37 +215,37 @@ static int str_split_parse(struct thread_data *td, ch=
ar *str,
 	if (odir) {
 		ddir =3D strchr(odir + 1, ',');
 		if (ddir) {
-			ret =3D fn(&td->o, DDIR_TRIM, ddir + 1, data);
+			ret =3D fn(&td->o, eo, DDIR_TRIM, ddir + 1, data);
 			if (!ret)
 				*ddir =3D '\0';
 		} else {
 			char *op;
=20
 			op =3D strdup(odir + 1);
-			ret =3D fn(&td->o, DDIR_TRIM, op, data);
+			ret =3D fn(&td->o, eo, DDIR_TRIM, op, data);
=20
 			free(op);
 		}
 		if (!ret)
-			ret =3D fn(&td->o, DDIR_WRITE, odir + 1, data);
+			ret =3D fn(&td->o, eo, DDIR_WRITE, odir + 1, data);
 		if (!ret) {
 			*odir =3D '\0';
-			ret =3D fn(&td->o, DDIR_READ, str, data);
+			ret =3D fn(&td->o, eo, DDIR_READ, str, data);
 		}
 	} else {
 		char *op;
=20
 		op =3D strdup(str);
-		ret =3D fn(&td->o, DDIR_WRITE, op, data);
+		ret =3D fn(&td->o, eo, DDIR_WRITE, op, data);
 		free(op);
=20
 		if (!ret) {
 			op =3D strdup(str);
-			ret =3D fn(&td->o, DDIR_TRIM, op, data);
+			ret =3D fn(&td->o, eo, DDIR_TRIM, op, data);
 			free(op);
 		}
 		if (!ret)
-			ret =3D fn(&td->o, DDIR_READ, str, data);
+			ret =3D fn(&td->o, eo, DDIR_READ, str, data);
 	}
=20
 	return ret;
@@ -270,7 +262,7 @@ static int str_bssplit_cb(void *data, const char *input=
)
 	strip_blank_front(&str);
 	strip_blank_end(str);
=20
-	ret =3D str_split_parse(td, str, bssplit_ddir, false);
+	ret =3D str_split_parse(td, str, bssplit_ddir, NULL, false);
=20
 	if (parse_dryrun()) {
 		int i;
@@ -906,8 +898,8 @@ static int str_sfr_cb(void *data, const char *str)
 }
 #endif
=20
-static int zone_split_ddir(struct thread_options *o, enum fio_ddir ddir,
-			   char *str, bool absolute)
+static int zone_split_ddir(struct thread_options *o, void *eo,
+			   enum fio_ddir ddir, char *str, bool absolute)
 {
 	unsigned int i, perc, perc_missing, sperc, sperc_missing;
 	struct split split;
@@ -1012,7 +1004,7 @@ static int parse_zoned_distribution(struct thread_dat=
a *td, const char *input,
 	}
 	str +=3D strlen(pre);
=20
-	ret =3D str_split_parse(td, str, zone_split_ddir, absolute);
+	ret =3D str_split_parse(td, str, zone_split_ddir, NULL, absolute);
=20
 	free(p);
=20
diff --git a/thread_options.h b/thread_options.h
index 4b4ecfe1..7133faf6 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -44,6 +44,12 @@ enum dedupe_mode {
 #define BSSPLIT_MAX	64
 #define ZONESPLIT_MAX	256
=20
+struct split {
+	unsigned int nr;
+	unsigned long long val1[ZONESPLIT_MAX];
+	unsigned long long val2[ZONESPLIT_MAX];
+};
+
 struct bssplit {
 	uint64_t bs;
 	uint32_t perc;
@@ -678,4 +684,13 @@ extern void convert_thread_options_to_net(struct threa=
d_options_pack *top, struc
 extern int fio_test_cconv(struct thread_options *);
 extern void options_default_fill(struct thread_options *o);
=20
+typedef int (split_parse_fn)(struct thread_options *, void *,
+			     enum fio_ddir, char *, bool);
+
+extern int str_split_parse(struct thread_data *td, char *str,
+			   split_parse_fn *fn, void *eo, bool data);
+
+extern int split_parse_ddir(struct thread_options *o, struct split *split,
+			    char *str, bool absolute, unsigned int max_splits);
+
 #endif
--=20
2.31.1

