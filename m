Return-Path: <xaaronc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130412063851.GH12244@kernel.dk>
References: <CAKCZDgkbxsgB-LDLSSJr3bm2j-aEj783kLT52h9emb18Rs1pUg@mail.gmail.com>
	<1C4A98C0-A6F6-4E57-8A97-C4E8D253D819@intel.com>
	<CAKCZDgmiGQFX1kHrjA9zR_LJLxw-rBotyCXegqQG0gdN99cOtg@mail.gmail.com>
	<CAKCZDgkybSpM5r6b46qO7MsRy6BdFW3O_CAGtoc=8N4zSB5Lpg@mail.gmail.com>
	<20130412055808.GE12244@kernel.dk>
	<CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
	<20130412061806.GF12244@kernel.dk>
	<CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
	<20130412063005.GG12244@kernel.dk>
	<CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
	<20130412063851.GH12244@kernel.dk>
Date: Fri, 12 Apr 2013 16:51:31 +1000
Message-ID: <CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
Subject: Re: Make FIO for Android
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: multipart/mixed; boundary=047d7b4725dc524b3404da24555a
To: Jens Axboe <axboe@kernel.dk>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7b4725dc524b3404da24555a
Content-Type: text/plain; charset=ISO-8859-1

On 12 April 2013 16:38, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Apr 12 2013, Aaron Carroll wrote:
>> On 12 April 2013 16:30, Jens Axboe <axboe@kernel.dk> wrote:
>> > Great, thanks! Will see if I can't get that asm android happy too.
>>
>> Thanks.  Does it make sense to use the GCC builtin __get_cpuid() ?
>> That seems to build fine both native x86 and Android/x86 here.
>
> Depends on when that was introduced. You'd be surprised to find the
> ancient distros that some people build it on... But the cpuid stuff
> should be basic enough that it isn't a lot of trouble to carry it. At
> least when we figure out why the Android NDK doesn't like the current
> restraints :-)

Digging around the GCC headers seems to have helped.  If you change
the constraint on ebx to:
        : "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
then it builds.

The relevant comment from cpuid.h:
  /* %ebx may be the PIC register.  */
which is ifdef'd on __PIC__

Dunno what that means, but it builds with that, plus a very small
Android-specific fix.  Both in attached patch.


      -- Aaron

--047d7b4725dc524b3404da24555a
Content-Type: application/octet-stream; name="android-x86.patch"
Content-Disposition: attachment; filename="android-x86.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfezwqvc0

ZGlmZiAtLWdpdCBhL2FyY2gvYXJjaC14ODYtY29tbW9uLmggYi9hcmNoL2FyY2gteDg2LWNvbW1v
bi5oCmluZGV4IDc4ZmQ0MGMuLmM4ZWM4ZDkgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJjaC14ODYtY29t
bW9uLmgKKysrIGIvYXJjaC9hcmNoLXg4Ni1jb21tb24uaApAQCAtNyw3ICs3LDcgQEAgc3RhdGlj
IGlubGluZSB2b2lkIGRvX2NwdWlkKHVuc2lnbmVkIGludCAqZWF4LCB1bnNpZ25lZCBpbnQgKmVi
eCwKIAkJCSAgICB1bnNpZ25lZCBpbnQgKmVjeCwgdW5zaWduZWQgaW50ICplZHgpCiB7CiAJYXNt
IHZvbGF0aWxlKCJjcHVpZCIKLQkJOiAiPWEiICgqZWF4KSwgIj1iIiAoKmVieCksICI9YyIgKCpl
Y3gpLCAiPWQiICgqZWR4KQorCQk6ICI9YSIgKCplYXgpLCAiPXIiICgqZWJ4KSwgIj1jIiAoKmVj
eCksICI9ZCIgKCplZHgpCiAJCTogIjAiICgqZWF4KSwgIjIiICgqZWN4KQogCQk6ICJtZW1vcnki
KTsKIH0KZGlmZiAtLWdpdCBhL29zL29zLWFuZHJvaWQuaCBiL29zL29zLWFuZHJvaWQuaAppbmRl
eCBiODQ0OTgyLi5kZjIyMzMzIDEwMDY0NAotLS0gYS9vcy9vcy1hbmRyb2lkLmgKKysrIGIvb3Mv
b3MtYW5kcm9pZC5oCkBAIC0xMyw2ICsxMyw3IEBACiAjaW5jbHVkZSA8c2NoZWQuaD4KICNpbmNs
dWRlIDxsaW51eC91bmlzdGQuaD4KICNpbmNsdWRlIDxsaW51eC9tYWpvci5oPgorI2luY2x1ZGUg
PGFzbS9ieXRlb3JkZXIuaD4KIAogI2luY2x1ZGUgImJpbmplY3QuaCIKICNpbmNsdWRlICIuLi9m
aWxlLmgiCg==
--047d7b4725dc524b3404da24555a--


