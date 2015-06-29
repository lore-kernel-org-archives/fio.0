Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55918E78.2050706@kernel.dk>
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
 <5591687D.6040803@kernel.dk> <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com>
 <55916A66.5080303@kernel.dk> <55916C87.1030408@kernel.dk> <CAB-428=ToOGYb=5r6VhORWiFqXoHk6N8tMX8HbUr2_Cctf9oWw@mail.gmail.com>
 <55918558.8090006@kernel.dk> <CAB-428=30M7HXTfL4P3KpyjAG3dqMA9vVirc8iyjbO-8eAgDrQ@mail.gmail.com>
 <55918E78.2050706@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 29 Jun 2015 13:58:27 -0500
Message-ID: <CAB-428kYoWm-SqfCpQRa2z6-fb=7X+kkNC7hfOV8HOUU-TV4PQ@mail.gmail.com>
Subject: Re: competime_assert failure without -O3 optimization flag expected ?
Content-Type: multipart/mixed; boundary=001a11353af62846320519acafac
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--001a11353af62846320519acafac
Content-Type: text/plain; charset=UTF-8

Make sens Jens. I did not get what you told me in the first place. Let
me know if this would fix it. It works for me with GCC 4.6 (patch file
is also attached):

diff --git a/fio-arh/compiler/compiler.h b/fio-arh/compiler/compiler.h
index 40e857c..c9f8776 100644
--- a/fio-arh/compiler/compiler.h
+++ b/fio-arh/compiler/compiler.h
@@ -1,5 +1,6 @@
 #ifndef FIO_COMPILER_H
 #define FIO_COMPILER_H
+#include <assert.h>

 #if __GNUC__ >= 4
 #include "compiler-gcc4.h"
@@ -33,6 +34,11 @@
  1; \
 })

+
+#if defined(CONFIG_STATIC_ASSERT)
+#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
+
+#else
 #ifndef __compiletime_error
 #define __compiletime_error(message)
 #endif
@@ -55,4 +61,6 @@
 #define compiletime_assert(condition, msg) \
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

+#endif
+
 #endif
diff --git a/fio-arh/configure b/fio-arh/configure
index e459d63..ab85936 100755
--- a/fio-arh/configure
+++ b/fio-arh/configure
@@ -1492,6 +1492,21 @@ if compile_prog "" "" "getmntinfo"; then
 fi
 echo "getmntinfo                    $getmntinfo"

+##########################################
+# Check whether we have _Static_assert
+static_assert="no"
+cat > $TMPC << EOF
+#include <assert.h>
+int main(int argc, char **argv)
+{
+  _Static_assert( 1 == 1 , "Check");
+  return 0 ;
+}
+EOF
+if compile_prog "" "" "static_assert"; then
+    static_assert="yes"
+fi
+echo "Static Assert                 $static_assert"
 #############################################################################

 if test "$wordsize" = "64" ; then
@@ -1671,6 +1686,9 @@ fi
 if test "$getmntinfo" = "yes" ; then
   output_sym "CONFIG_GETMNTINFO"
 fi
+if test "$static_assert" = "yes" ; then
+  output_sym "CONFIG_STATIC_ASSERT"
+fi

 if test "$zlib" = "no" ; then

--001a11353af62846320519acafac
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ibi9oiao0

ZGlmZiAtLWdpdCBhL2Zpby1hcmgvY29tcGlsZXIvY29tcGlsZXIuaCBiL2Zpby1hcmgvY29tcGls
ZXIvY29tcGlsZXIuaAppbmRleCA0MGU4NTdjLi5jOWY4Nzc2IDEwMDY0NAotLS0gYS9maW8tYXJo
L2NvbXBpbGVyL2NvbXBpbGVyLmgKKysrIGIvZmlvLWFyaC9jb21waWxlci9jb21waWxlci5oCkBA
IC0xLDUgKzEsNiBAQAogI2lmbmRlZiBGSU9fQ09NUElMRVJfSAogI2RlZmluZSBGSU9fQ09NUElM
RVJfSAorI2luY2x1ZGUgPGFzc2VydC5oPgogCiAjaWYgX19HTlVDX18gPj0gNAogI2luY2x1ZGUg
ImNvbXBpbGVyLWdjYzQuaCIKQEAgLTMzLDYgKzM0LDExIEBACiAJMTsgXAogfSkKIAorCisjaWYg
ZGVmaW5lZChDT05GSUdfU1RBVElDX0FTU0VSVCkKKyNkZWZpbmUgY29tcGlsZXRpbWVfYXNzZXJ0
KGNvbmRpdGlvbiwgbXNnKSBfU3RhdGljX2Fzc2VydChjb25kaXRpb24sIG1zZykKKworI2Vsc2UK
ICNpZm5kZWYgX19jb21waWxldGltZV9lcnJvcgogI2RlZmluZSBfX2NvbXBpbGV0aW1lX2Vycm9y
KG1lc3NhZ2UpCiAjZW5kaWYKQEAgLTU1LDQgKzYxLDYgQEAKICNkZWZpbmUgY29tcGlsZXRpbWVf
YXNzZXJ0KGNvbmRpdGlvbiwgbXNnKSBcCiAJX2NvbXBpbGV0aW1lX2Fzc2VydChjb25kaXRpb24s
IG1zZywgX19jb21waWxldGltZV9hc3NlcnRfLCBfX0xJTkVfXykKIAorI2VuZGlmIAorCiAjZW5k
aWYKZGlmZiAtLWdpdCBhL2Zpby1hcmgvY29uZmlndXJlIGIvZmlvLWFyaC9jb25maWd1cmUKaW5k
ZXggZTQ1OWQ2My4uYWI4NTkzNiAxMDA3NTUKLS0tIGEvZmlvLWFyaC9jb25maWd1cmUKKysrIGIv
ZmlvLWFyaC9jb25maWd1cmUKQEAgLTE0OTIsNiArMTQ5MiwyMSBAQCBpZiBjb21waWxlX3Byb2cg
IiIgIiIgImdldG1udGluZm8iOyB0aGVuCiBmaQogZWNobyAiZ2V0bW50aW5mbyAgICAgICAgICAg
ICAgICAgICAgJGdldG1udGluZm8iCiAKKyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIworIyBDaGVjayB3aGV0aGVyIHdlIGhhdmUgX1N0YXRpY19hc3NlcnQKK3N0YXRp
Y19hc3NlcnQ9Im5vIgorY2F0ID4gJFRNUEMgPDwgRU9GCisjaW5jbHVkZSA8YXNzZXJ0Lmg+Citp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCit7CisgIF9TdGF0aWNfYXNzZXJ0KCAxID09
IDEgLCAiQ2hlY2siKTsKKyAgcmV0dXJuIDAgOworfQorRU9GCitpZiBjb21waWxlX3Byb2cgIiIg
IiIgInN0YXRpY19hc3NlcnQiOyB0aGVuCisgICAgc3RhdGljX2Fzc2VydD0ieWVzIgorZmkKK2Vj
aG8gIlN0YXRpYyBBc3NlcnQgICAgICAgICAgICAgICAgICRzdGF0aWNfYXNzZXJ0IgogIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMKIAogaWYgdGVzdCAiJHdvcmRzaXplIiA9ICI2NCIgOyB0aGVuCkBAIC0x
NjcxLDYgKzE2ODYsOSBAQCBmaQogaWYgdGVzdCAiJGdldG1udGluZm8iID0gInllcyIgOyB0aGVu
CiAgIG91dHB1dF9zeW0gIkNPTkZJR19HRVRNTlRJTkZPIgogZmkKK2lmIHRlc3QgIiRzdGF0aWNf
YXNzZXJ0IiA9ICJ5ZXMiIDsgdGhlbgorICBvdXRwdXRfc3ltICJDT05GSUdfU1RBVElDX0FTU0VS
VCIKK2ZpCiAKIGlmIHRlc3QgIiR6bGliIiA9ICJubyIgOyB0aGVuCiAgIGVjaG8gIkNvbnNpZGVy
IGluc3RhbGxpbmcgemxpYi1kZXYgKHpsaWItZGV2ZWwpLCBzb21lIGZpbyBmZWF0dXJlcyBkZXBl
bmQgb24gaXQuIgpkaWZmIC0tZ2l0IGEvZmlvLWFyaC90L2F4bWFwIGIvZmlvLWFyaC90L2F4bWFw
CmRlbGV0ZWQgZmlsZSBtb2RlIDEwMDc1NQppbmRleCAyZmFjYWJlLi4wMDAwMDAwCkJpbmFyeSBm
aWxlcyBhL2Zpby1hcmgvdC9heG1hcCBhbmQgL2Rldi9udWxsIGRpZmZlcgpkaWZmIC0tZ2l0IGEv
ZmlvLWFyaC90L2Zpby1idHJhY2UyZmlvIGIvZmlvLWFyaC90L2Zpby1idHJhY2UyZmlvCmRlbGV0
ZWQgZmlsZSBtb2RlIDEwMDc1NQppbmRleCAxM2FkZGJhLi4wMDAwMDAwCkJpbmFyeSBmaWxlcyBh
L2Zpby1hcmgvdC9maW8tYnRyYWNlMmZpbyBhbmQgL2Rldi9udWxsIGRpZmZlcgpkaWZmIC0tZ2l0
IGEvZmlvLWFyaC90L2Zpby1kZWR1cGUgYi9maW8tYXJoL3QvZmlvLWRlZHVwZQpkZWxldGVkIGZp
bGUgbW9kZSAxMDA3NTUKaW5kZXggMjU3MDA4MS4uMDAwMDAwMApCaW5hcnkgZmlsZXMgYS9maW8t
YXJoL3QvZmlvLWRlZHVwZSBhbmQgL2Rldi9udWxsIGRpZmZlcgpkaWZmIC0tZ2l0IGEvZmlvLWFy
aC90L2Zpby1nZW56aXBmIGIvZmlvLWFyaC90L2Zpby1nZW56aXBmCmRlbGV0ZWQgZmlsZSBtb2Rl
IDEwMDc1NQppbmRleCBkMTMzYThhLi4wMDAwMDAwCkJpbmFyeSBmaWxlcyBhL2Zpby1hcmgvdC9m
aW8tZ2VuemlwZiBhbmQgL2Rldi9udWxsIGRpZmZlcgpkaWZmIC0tZ2l0IGEvZmlvLWFyaC90L2ll
ZWU3NTQgYi9maW8tYXJoL3QvaWVlZTc1NApkZWxldGVkIGZpbGUgbW9kZSAxMDA3NTUKaW5kZXgg
M2M3ZTkyNC4uMDAwMDAwMApCaW5hcnkgZmlsZXMgYS9maW8tYXJoL3QvaWVlZTc1NCBhbmQgL2Rl
di9udWxsIGRpZmZlcgpkaWZmIC0tZ2l0IGEvZmlvLWFyaC90L2xmc3ItdGVzdCBiL2Zpby1hcmgv
dC9sZnNyLXRlc3QKZGVsZXRlZCBmaWxlIG1vZGUgMTAwNzU1CmluZGV4IDYwMmVhOGQuLjAwMDAw
MDAKQmluYXJ5IGZpbGVzIGEvZmlvLWFyaC90L2xmc3ItdGVzdCBhbmQgL2Rldi9udWxsIGRpZmZl
cgpkaWZmIC0tZ2l0IGEvZmlvLWFyaC90L3N0ZXN0IGIvZmlvLWFyaC90L3N0ZXN0CmRlbGV0ZWQg
ZmlsZSBtb2RlIDEwMDc1NQppbmRleCBmNDc0M2YzLi4wMDAwMDAwCkJpbmFyeSBmaWxlcyBhL2Zp
by1hcmgvdC9zdGVzdCBhbmQgL2Rldi9udWxsIGRpZmZlcgo=
--001a11353af62846320519acafac--

