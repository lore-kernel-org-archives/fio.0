Return-Path: <radha@google.com>
MIME-Version: 1.0
From: Radha Ramachandran <radha@google.com>
Date: Wed, 14 Jul 2010 12:10:04 -0600
Subject: Re: Patch to re-use already filled up pattern in io buffers
Message-ID: <AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyG-AQU8rqk@mail.gmail.com>
References: <AANLkTinGG7P6hY4ltETjYGkQVV51VfiiqBPRzM0SSzhu@mail.gmail.com>
	<4C3D5A43.6020005@fusionio.com>	<4C3D5CBF.3070108@fusionio.com>
In-Reply-To: <4C3D5CBF.3070108@fusionio.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyGAQU8rqkmailgmailco_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_002_AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyGAQU8rqkmailgmailco_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Jens,
As I was verifying the latest code from head, I realized that we
actually did not need the IO_U_F_FILLED flag, we can just
use(overload) the buf_filled_len to check if the buffer is actually
filled (as this is reset to 0 on a read). This also gave me slight
performance bump. Attached is the patch for it.
thanks
-radha


On Tue, Jul 13, 2010 at 11:44 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 07/14/2010 08:33 AM, Jens Axboe wrote:
>> On 07/14/2010 02:13 AM, Radha Ramachandran wrote:
>>> Hi Jens,
>>> I made changes to fio so we wld re-use the already populated io_u
>>> buffer (when there is a non-random pattern) during writes. That way
>>> only the header will be re-calculated for every I/O. This way the
>>> buffer wld get populated in the beginning and as long as the
>>> subsequent ios using the same io_u structure are writes and have same
>>> or less block size, it wld get re-used. If any of the subsequent i/o
>>> is a read or has a block size greater than the pre-filled one, then
>>> the buffer is invalidated and will be re-filled at the next write.
>>>
>>> Reason for this risky change: (Performance)
>>> I tested this change on a tmpfs(with no swap backing), with the
>>> following config file:
>>> [sscan_write]
>>> filename=3D/mytmpfs/datafile.tmp
>>> rw=3Dwrite
>>> bs=3D64k
>>> size=3D3G
>>> ioengine=3Dlibaio
>>> iodepth=3D1024
>>> iodepth_low=3D512
>>> runtime=3D10800
>>> bwavgtime=3D5000
>>> thread=3D1
>>> do_verify=3D0
>>> verify=3Dmeta
>>> verify_pattern=3D0x55aaa55a
>>> verify_interval=3D4k
>>> continue_on_error=3D1
>>>
>>> fio-1-41-6 gave 306MB/s and the new change had a performance of 1546MB/=
s
>>>
>>> Side effects/Risks:
>>> There is a risk with this fix, that if the buffer gets corrupted then
>>> the subsequent writes will also be corrupt. I think for both
>>> sequential writes and random writes (with verify, where the I/O log is
>>> replayed) we shld be able to find the first I/O that started with the
>>> corruption and if the buffer is getting corrupted, there are other
>>> issues here.
>>>
>>> Testing:
>>> I have tested this fix with sequential write(verify)/random read write
>>> mix combination(with verify).
>>>
>>> I think I have taken care of most of the case, but please let me know
>>> if there is anything I have missed. I have attached the patch along
>>> with this email. I think the performance improvement outweighs the
>>> risk associated with the fix. But I will let you decide if you wld
>>> like to pick it up.
>>
>> I will pick this up, the fill time is the reason for some of the
>> other hoops we jump through to try and avoid that when possible.
>> I don't think the risk of memory corruption is something we need
>> to consider. That could just as easily happen after the data
>> has been read anyway, both cases would result in a verify error.
>>
>
> I made a small change to turn ->buf_filled into an io_u
> flag. It would be nice if you could retest the current
> -git state and ensure that it works properly. I'm on the
> road the next ~10 days, so wont have a lot of testing time
> on my hands.
>
> --
> Jens Axboe
>
>

--_002_AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyGAQU8rqkmailgmailco_
Content-Type: text/x-diff; name="IO_U_F_FILLED.patch"
Content-Description: IO_U_F_FILLED.patch
Content-Disposition: attachment; filename="IO_U_F_FILLED.patch"; size=1851;
	creation-date="Wed, 14 Jul 2010 12:10:10 GMT";
	modification-date="Wed, 14 Jul 2010 12:10:10 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2lvX3UuYyBiL2lvX3UuYwppbmRleCA4OGIyYjlmLi5mMjdjZGRhIDEwMDY0
NAotLS0gYS9pb191LmMKKysrIGIvaW9fdS5jCkBAIC05ODgsNyArOTg4LDYgQEAgc3RydWN0IGlv
X3UgKmdldF9pb191KHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQpCiAJCQkgKiBSZXNldCB0aGUgYnVm
X2ZpbGxlZCBwYXJhbWV0ZXJzIHNvIG5leHQgdGltZSBpZiB0aGUKIAkJCSAqIGJ1ZmZlciBpcyB1
c2VkIGZvciB3cml0ZXMgaXQgaXMgcmVmaWxsZWQuCiAJCQkgKi8KLQkJCWlvX3UtPmZsYWdzICY9
IH5JT19VX0ZfRklMTEVEOwogCQkJaW9fdS0+YnVmX2ZpbGxlZF9sZW4gPSAwOwogCQl9CiAJfQpk
aWZmIC0tZ2l0IGEvaW9lbmdpbmUuaCBiL2lvZW5naW5lLmgKaW5kZXggMzQzYjA2Zi4uZTlmNWQ5
MiAxMDA2NDQKLS0tIGEvaW9lbmdpbmUuaAorKysgYi9pb2VuZ2luZS5oCkBAIC04LDcgKzgsNiBA
QCBlbnVtIHsKIAlJT19VX0ZfRkxJR0hUCQk9IDEgPDwgMSwKIAlJT19VX0ZfRlJFRV9ERUYJCT0g
MSA8PCAyLAogCUlPX1VfRl9JTl9DVVJfREVQVEgJPSAxIDw8IDMsCi0JSU9fVV9GX0ZJTExFRAkJ
PSAxIDw8IDQsCiB9OwogCiAvKgpkaWZmIC0tZ2l0IGEvdmVyaWZ5LmMgYi92ZXJpZnkuYwppbmRl
eCAwOThjMTliLi40MmVhNDYyIDEwMDY0NAotLS0gYS92ZXJpZnkuYworKysgYi92ZXJpZnkuYwpA
QCAtMzAsMjIgKzMwLDE5IEBAIHZvaWQgZmlsbF9wYXR0ZXJuKHN0cnVjdCB0aHJlYWRfZGF0YSAq
dGQsIHZvaWQgKnAsIHVuc2lnbmVkIGludCBsZW4sIHN0cnVjdCBpb191CiAJCWZpbGxfcmFuZG9t
X2J1ZihwLCBsZW4pOwogCQlicmVhazsKIAljYXNlIDE6Ci0JCWlmICgoaW9fdS0+ZmxhZ3MgJiBJ
T19VX0ZfRklMTEVEKSAmJgotCQkgICAgIGlvX3UtPmJ1Zl9maWxsZWRfbGVuID49IGxlbikgewor
CQlpZiAoaW9fdS0+YnVmX2ZpbGxlZF9sZW4gPj0gbGVuKSB7CiAJCQlkcHJpbnQoRkRfVkVSSUZZ
LCAidXNpbmcgYWxyZWFkeSBmaWxsZWQgdmVyaWZ5IHBhdHRlcm4gYj0wIGxlbj0ldVxuIiwgbGVu
KTsKIAkJCXJldHVybjsKIAkJfQogCQlkcHJpbnQoRkRfVkVSSUZZLCAiZmlsbCB2ZXJpZnkgcGF0
dGVybiBiPTAgbGVuPSV1XG4iLCBsZW4pOwogCQltZW1zZXQocCwgdGQtPm8udmVyaWZ5X3BhdHRl
cm5bMF0sIGxlbik7Ci0JCWlvX3UtPmZsYWdzIHw9IElPX1VfRl9GSUxMRUQ7CiAJCWlvX3UtPmJ1
Zl9maWxsZWRfbGVuID0gbGVuOwogCQlicmVhazsKIAlkZWZhdWx0OiB7CiAJCXVuc2lnbmVkIGlu
dCBpID0gMCwgc2l6ZSA9IDA7CiAJCXVuc2lnbmVkIGNoYXIgKmIgPSBwOwogCi0JCWlmICgoaW9f
dS0+ZmxhZ3MgJiBJT19VX0ZfRklMTEVEKSAmJgotCQkgICAgIGlvX3UtPmJ1Zl9maWxsZWRfbGVu
ID49IGxlbikgeworCQlpZiAoaW9fdS0+YnVmX2ZpbGxlZF9sZW4gPj0gbGVuKSB7CiAJCQlkcHJp
bnQoRkRfVkVSSUZZLCAidXNpbmcgYWxyZWFkeSBmaWxsZWQgdmVyaWZ5IHBhdHRlcm4gYj0lZCBs
ZW49JXVcbiIsCiAJCQkJCXRkLT5vLnZlcmlmeV9wYXR0ZXJuX2J5dGVzLCBsZW4pOwogCQkJcmV0
dXJuOwpAQCAtNjAsNyArNTcsNiBAQCB2b2lkIGZpbGxfcGF0dGVybihzdHJ1Y3QgdGhyZWFkX2Rh
dGEgKnRkLCB2b2lkICpwLCB1bnNpZ25lZCBpbnQgbGVuLCBzdHJ1Y3QgaW9fdQogCQkJbWVtY3B5
KGIraSwgdGQtPm8udmVyaWZ5X3BhdHRlcm4sIHNpemUpOwogCQkJaSArPSBzaXplOwogCQl9Ci0J
CWlvX3UtPmZsYWdzIHw9IElPX1VfRl9GSUxMRUQ7CiAJCWlvX3UtPmJ1Zl9maWxsZWRfbGVuID0g
bGVuOwogCQlicmVhazsKIAkJfQo=

--_002_AANLkTilg01hs2RgmLRSSbKcAlJPcr6YL2kyGAQU8rqkmailgmailco_--


