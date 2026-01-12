Received: from mx0b-001ed902.pphosted.com (mx0b-001ed902.pphosted.com [205.220.174.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A0A2B2D7
	for <fio@vger.kernel.org>; Mon, 12 Jan 2026 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.174.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768249412; cv=none; b=n5fS87zaX9rq1ZD8nyj5WJO1sAFnqj+X9KvryODPVJOKTJeluiDwvTcdb+p0Yt5ZHDWJ4V2TvD1bbk/W3LC0NQ7dSzTzAk3LrlNlZhBhVuztx1LkyD+NgAEiQvThATk6rJRBUsAkM0ex8+slwnpdwZ4l3vpDBJfTD775IquxP9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768249412; c=relaxed/simple;
	bh=nQeGxU2KPZb/CnqND+jh9Ja3d04ofBw7r6po2+mVQUc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=C+AI7+Kg4lLCxyPox6C9Ckf4Rn5vXB+choUbhWvZgKiP4ZR4UPTdaBA9c3/PNbtVUkOmMYYWkPGPasO7YamTtq+X8qOpWadCMYx9ZiLAqWAi7AhjpGA04o1aamiMaGiEkQwLdyZEV+kttoYyrSdkJLB8ga9eGwYupO7Fn6a7UK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dropbox.com; spf=pass smtp.mailfrom=dropbox.com; dkim=pass (1024-bit key) header.d=dropbox.com header.i=@dropbox.com header.b=PPSsTWeh; arc=none smtp.client-ip=205.220.174.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dropbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dropbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dropbox.com header.i=@dropbox.com header.b="PPSsTWeh"
Received: from pps.filterd (m0324676.ppops.net [127.0.0.1])
	by mx0b-001ed902.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60CKEZqu661633
	for <fio@vger.kernel.org>; Mon, 12 Jan 2026 20:21:38 GMT
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0b-001ed902.pphosted.com (PPS) with ESMTPS id 4bm1jt9j7u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=OK)
	for <fio@vger.kernel.org>; Mon, 12 Jan 2026 20:21:37 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7cdcd09efc6so21267941a34.0
        for <fio@vger.kernel.org>; Mon, 12 Jan 2026 12:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dropbox.com; s=corp; t=1768249297; x=1768854097; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=APqE0dg0n9p2yGm4NPXIGwsC8F4rFlrE7WKSrTceA2I=;
        b=PPSsTWeh4GAXx/d9ueo8Dsbw/dQYqRO4s2CNE7aSr0IC87/Q7SCNNcGgpaT11Qxme5
         B662er9mVCQHIUXblNuz24sQGDBx3grOHFZevWtvJbbREP+she/+S30uFCtuIfN7JZvH
         cLDXVggZZAQv7P7bpJ4Mxxr9Ipjiejr81D2c4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768249297; x=1768854097;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=APqE0dg0n9p2yGm4NPXIGwsC8F4rFlrE7WKSrTceA2I=;
        b=hZzwuSY+3xwdiUNvvMK7KQf54MPqjostuHVadmpsbJWvQAUNOePtpxFltKj0sMAm86
         hECKb6WuUpsNz6sQjp6hFHLYuoMr814qsnrUkHpAlQ0X9Qp9iBwFWDdqlN2CXsTICkPb
         GLYrBiYfhT+cZrf4vq+4FCcdsuA4RQmqo0U4v0jNkSEE3e9GumfJD0Gjglel6FanSsX2
         ZX2i8U35lUxxZLAu18LnKYACS8/A0ldeMSa9goQKuHYhpQ4aABBChflfnqk7M6Mtz3T6
         vw9zkEX4/c6fSiu/EVkxx54j86yTa3QqtbvNLkt1E0o3D3iWkBOGiNyelQef9Y0vl0O9
         k5fw==
X-Gm-Message-State: AOJu0Yzjwnp2ImLvElHXGLsKfIJEtJeswiUB26Q8S4fktAy8xlqnIs1O
	d2vIclbt70/UFths/eriXDI3Zc0rCngVrTYiMkFs3MNmz+nEAUXkVwODK5DUpYyzS+M1pj1v57b
	yWo44zLR7AcxePyNIbwdtqcwobVf41fUQ4H001xie0VVeI8kOFS4rItX40gHOfk2XfxPGk1IRMn
	XW30u+rnnEPBcAlCRrr3Sz5oyoWbA0ItpxQDm3qg==
X-Gm-Gg: AY/fxX4cWnQ3MbmBfTEx2YLDKGoNNLw0KALXQeT8/YjGWfJTo9SB+mjt9zSsokF0sss
	fUKmOxDw1GTbn2bzefZPgvjUVOiNCVH4oeCrSJCkzECsOYTwPqyLApeVjy14cVFOksWQV+AhBqh
	SINX/1XKjcrvBfLh8OtJApKvt9p6Xnq2sR8+luqMMxX+w2hY8Y4coY3Xx/0jphieRd4cA=
X-Received: by 2002:a4a:e249:0:b0:65f:5bc0:7b2f with SMTP id 006d021491bc7-65f5bc07d10mr6141851eaf.46.1768249296871;
        Mon, 12 Jan 2026 12:21:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlhpZDReDcfHTxlcnKRtBv5gtmBx8v6o7Y17B0rvg2C87D2UOQwJAvuPWEnq/mk3MzpUksLfm2XFpWAecWYwc=
X-Received: by 2002:a4a:e249:0:b0:65f:5bc0:7b2f with SMTP id
 006d021491bc7-65f5bc07d10mr6141842eaf.46.1768249296507; Mon, 12 Jan 2026
 12:21:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vishal Jose Mannanal <vishaljm@dropbox.com>
Date: Mon, 12 Jan 2026 12:21:25 -0800
X-Gm-Features: AZwV_QjFgjXRcfGHlPOMbJwnfDJlWD_4PkCv_VYXg59ved17rFX-XFjUDF6dino
Message-ID: <CAOUciekiQpCBKAkAmnNF_3P_tJyL0uTGZdpq8eYY1V0Obrm8mA@mail.gmail.com>
Subject: [PATCH] fio: Add ZBD support to io_uring engines
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Eric Shobe <shobe@dropbox.com>
Content-Type: multipart/mixed; boundary="0000000000003199080648369f7d"
X-Authority-Analysis: v=2.4 cv=Wu8m8Nfv c=1 sm=1 tr=0 ts=696557d1 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=vUbySO9Y5rIA:10 a=kC_G02pF9r0A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=-B9z25BF-Yht86Hq5W0A:9 a=QEXdDO2ut3YA:10
 a=BL7qrvUWpmR5OOvcvWYA:9 a=lcECZwdxs1qYi60n:21 a=MyqjuCZlkaYFs_EvEhUA:9
 a=B2y7HmGcmWMA:10 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-GUID: L_n6FE_xC2viII1NBK9opgmfjiusDzVX
X-Proofpoint-ORIG-GUID: L_n6FE_xC2viII1NBK9opgmfjiusDzVX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDE2OSBTYWx0ZWRfX2tzTz8siH1OS
 KY8EL/Ym1ZI0S8ejRUMT5iTcgyfAm4oiOz6Bf9X5DjqW05E/3jUB9JuFBur0zX+FDOwSXvbBAZQ
 WgbERLEB8h/BYmJkJGNRfzvt1Mk2XhIreR1YKy9k4yZ97C4IRWQ5ronRDYfMsmRlirW7DtD7ypX
 +Tew4ptN+balg9g5eJZzfK1Q/fLW+HcAHKTmCz6o/5ilxPCeVFjilHZNDsBu6F84u/KbyqPtq+j
 maXJvBbrutivgMrzCUB45u9JzErPcUS6iFqj/hSC+RPwICLcTwLf6DhpeCUlLeTVwykPIJ3JwVr
 q+/AK+6HoUUgXuZwVZWfEPtoh9zZEnTwDH39KU2sSwouC3ODjgoo0m1fKK2navaQk6cOQyQhBpT
 lPzqXDx/8YkfTQ2hlce/sxIox9zFUh2hTGRE/wbrRc7rMDIMGU5kbfE5JaTLNGE89jB3twsYd7Y
 1Qv0Ucb1kQqo/cwhMog==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_06,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601120169

--0000000000003199080648369f7d
Content-Type: multipart/alternative; boundary="0000000000003199060648369f7b"

--0000000000003199060648369f7b
Content-Type: text/plain; charset="UTF-8"

Hi Jens and fio maintainers,

We've been working with zoned block devices (ZBD) and noticed that the
io_uring engines don't support zonemode=zbd, which prevents leveraging
io_uring's performance benefits for zone testing workloads in SMR (Shingled
Magnetic Recording) drives. This finding came from our analysis, while
testing the integration of io_uring into the Dropbox storage stack. An
io_uring patch enabling ZBD support will follow shortly.

The attached patch adds ZBD hooks to both io_uring and io_uring_cmd
engines. The implementation is straightforward, where it delegates to the
existing blkzoned and nvme helper functions, maintaining consistency with
other engines.

What this enables:

   - Zone operations (report, reset, finish, max_open_zones tracking)
   - Proper write pointer management
   - Support for both traditional SMR/ZAC and NVMe ZNS devices

I've tested this on SMR drives with the io_uring engine and it works well.
The io_uring_cmd part should work for ZNS devices as it reuses the existing
fio_nvme_* implementations.

Sample fio job:

> [zbd-test]
> ioengine=io_uring
> direct=1
> bs=128k
> zonemode=zbd
> filename=/dev/sdg


Thanks,
Vishal Jose Mannanal
Dropbox Inc.

--0000000000003199060648369f7b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Jens and fio maintainers,<br><br>We&#39;ve been working=
 with zoned block devices (ZBD) and noticed that the io_uring engines don&#=
39;t support zonemode=3Dzbd, which prevents leveraging io_uring&#39;s perfo=
rmance benefits for zone testing workloads in=C2=A0SMR (Shingled Magnetic R=
ecording) drives. This finding came from our analysis, while testing the in=
tegration of io_uring into the Dropbox storage stack. An io_uring patch ena=
bling ZBD support will follow shortly.<br><br>The attached patch adds ZBD h=
ooks to both io_uring and io_uring_cmd engines. The implementation is strai=
ghtforward, where it delegates to the existing blkzoned and nvme helper fun=
ctions, maintaining consistency with other engines.<br><br>What this enable=
s:<div><ul><li>Zone operations (report, reset, finish, max_open_zones track=
ing)</li><li>Proper write pointer management</li><li>Support for both tradi=
tional SMR/ZAC and NVMe ZNS devices</li></ul>I&#39;ve tested this on SMR dr=
ives with the io_uring engine and it works well. The io_uring_cmd part shou=
ld work for ZNS devices as it reuses the existing fio_nvme_* implementation=
s.</div><div><br></div><div>Sample fio job:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">[zbd-test]<br>ioengine=3Dio_uring<br>direct=3D1<br>bs=
=3D128k<br>zonemode=3Dzbd<br>filename=3D/dev/sdg</blockquote></div><div><br=
></div><div>Thanks,<br>Vishal Jose Mannanal<br>Dropbox Inc.</div></div>

--0000000000003199060648369f7b--
--0000000000003199080648369f7d
Content-Type: application/octet-stream; name="io_uring_zbd_support.patch"
Content-Disposition: attachment; filename="io_uring_zbd_support.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mkblrsmj0>
X-Attachment-Id: f_mkblrsmj0

RnJvbTogVmlzaGFsIEpvc2UgTWFubmFuYWwgPHZpc2hhbGptQGRyb3Bib3guY29tPgpEYXRlOiBU
aHUsIDExIEphbiAyMDI2IDE2OjMwOjAwICswMDAwClN1YmplY3Q6IFtQQVRDSF0gQWRkIFpCRCAo
Wm9uZWQgQmxvY2sgRGV2aWNlKSBzdXBwb3J0IHRvIGlvX3VyaW5nIGVuZ2luZXMKClRoaXMgcGF0
Y2ggYWRkcyBjb21wcmVoZW5zaXZlIFpCRCBzdXBwb3J0IHRvIGJvdGggaW9fdXJpbmcgYW5kIGlv
X3VyaW5nX2NtZAplbmdpbmVzLCBlbmFibGluZyB0aGVtIHRvIHdvcmsgd2l0aCB6b25lbW9kZT16
YmQgZm9yIGJvdGggdHJhZGl0aW9uYWwgem9uZWQKYmxvY2sgZGV2aWNlcyBsaWtlIFNNUiAoU2hp
bmdsZWQgTWFnbmV0aWMgUmVjb3JkaW5nKSBhbmQgTlZNZSBaTlMgKFpvbmVkIE5hbWVzcGFjZSkg
ZGV2aWNlcy4KCkNoYW5nZXMgaW5jbHVkZToKLSBaQkQgZnVuY3Rpb24gaW1wbGVtZW50YXRpb25z
IGZvciB6b25lIG1hbmFnZW1lbnQgb3BlcmF0aW9ucwotIEludGVncmF0aW9uIHdpdGggZXhpc3Rp
bmcgYmxrem9uZWQgYW5kIE5WTWUgWk5TIGludGVyZmFjZXMgIAotIFN1cHBvcnQgZm9yIHpvbmUg
cmVwb3J0aW5nLCByZXNldCwgZmluaXNoLCBhbmQgd3JpdGUgcG9pbnRlciBvcGVyYXRpb25zCi0g
UHJvcGVyIHpvbmVkIG1vZGVsIGRldGVjdGlvbiBmb3IgYm90aCBkZXZpY2UgdHlwZXMKClNpZ25l
ZC1vZmYtYnk6IFZpc2hhbCBKb3NlIE1hbm5hbmFsIDx2aXNoYWxqbUBkcm9wYm94LmNvbT4KLS0t
CiBlbmdpbmVzL2lvX3VyaW5nLmMgfCAxMjYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9lbmdpbmVzL2lvX3VyaW5nLmMgYi9lbmdpbmVzL2lvX3VyaW5nLmMKaW5kZXgg
MTIzNDU2Ny4uYWJjZGVmZyAxMDA2NDQKLS0tIGEvZW5naW5lcy9pb191cmluZy5jCisrKyBiL2Vu
Z2luZXMvaW9fdXJpbmcuYwpAQCAtMjYsNiArMjYsNyBAQAogI2luY2x1ZGUgIi4uL2xpYi90eXBl
cy5oIgogI2luY2x1ZGUgIi4uL29zL2xpbnV4L2lvX3VyaW5nLmgiCiAjaW5jbHVkZSAiY21kcHJp
by5oIgorI2luY2x1ZGUgInpiZC5oIgogI2luY2x1ZGUgIm52bWUuaCIKIAogI2luY2x1ZGUgPHN5
cy9zdGF0Lmg+CkBAIC0xNjUyLDYgKzE2NTMsMTI1IEBAIHN0YXRpYyBpbnQgZmlvX2lvcmluZ19j
bWRfZ2V0X2ZpbGVfc2l6ZShzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLAogCXJldHVybiBnZW5lcmlj
X2dldF9maWxlX3NpemUodGQsIGYpOwogfQogCitzdGF0aWMgaW50IGZpb19pb3JpbmdfZ2V0X3pv
bmVkX21vZGVsKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsCisJCQkJICAgICAgc3RydWN0IGZpb19m
aWxlICpmLAorCQkJCSAgICAgIGVudW0gemJkX3pvbmVkX21vZGVsICptb2RlbCkKK3sKKwlyZXR1
cm4gYmxrem9uZWRfZ2V0X3pvbmVkX21vZGVsKHRkLCBmLCBtb2RlbCk7Cit9CisKK3N0YXRpYyBp
bnQgZmlvX2lvcmluZ19yZXBvcnRfem9uZXMoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwKKwkJCQkg
ICBzdHJ1Y3QgZmlvX2ZpbGUgKmYsIHVpbnQ2NF90IG9mZnNldCwKKwkJCQkgICBzdHJ1Y3QgemJk
X3pvbmUgKnpiZHosCisJCQkJICAgdW5zaWduZWQgaW50IG5yX3pvbmVzKQoreworCXJldHVybiBi
bGt6b25lZF9yZXBvcnRfem9uZXModGQsIGYsIG9mZnNldCwgemJkeiwgbnJfem9uZXMpOworfQor
CitzdGF0aWMgaW50IGZpb19pb3JpbmdfcmVzZXRfd3Aoc3RydWN0IHRocmVhZF9kYXRhICp0ZCwg
c3RydWN0IGZpb19maWxlICpmLAorCQkJICAgICAgIHVpbnQ2NF90IG9mZnNldCwgdWludDY0X3Qg
bGVuZ3RoKQoreworCXJldHVybiBibGt6b25lZF9yZXNldF93cCh0ZCwgZiwgb2Zmc2V0LCBsZW5n
dGgpOworfQorCitzdGF0aWMgaW50IGZpb19pb3JpbmdfZ2V0X21heF9vcGVuX3pvbmVzKHN0cnVj
dCB0aHJlYWRfZGF0YSAqdGQsCisJCQkJCSBzdHJ1Y3QgZmlvX2ZpbGUgKmYsCisJCQkJCSB1bnNp
Z25lZCBpbnQgKm1heF9vcGVuX3pvbmVzKQoreworCXJldHVybiBibGt6b25lZF9nZXRfbWF4X29w
ZW5fem9uZXModGQsIGYsIG1heF9vcGVuX3pvbmVzKTsKK30KKworc3RhdGljIGludCBmaW9faW9y
aW5nX2ZpbmlzaF96b25lKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVjdCBmaW9fZmlsZSAq
ZiwKKwkJCQkgIHVpbnQ2NF90IG9mZnNldCwgdWludDY0X3QgbGVuZ3RoKQoreworCXJldHVybiBi
bGt6b25lZF9maW5pc2hfem9uZSh0ZCwgZiwgb2Zmc2V0LCBsZW5ndGgpOworfQorCitzdGF0aWMg
aW50IGZpb19pb3JpbmdfbW92ZV96b25lX3dwKHN0cnVjdCB0aHJlYWRfZGF0YSAqdGQsIHN0cnVj
dCBmaW9fZmlsZSAqZiwKKwkJCQkgICBzdHJ1Y3QgemJkX3pvbmUgKnosIHVpbnQ2NF90IGxlbmd0
aCwKKwkJCQkgICBjb25zdCBjaGFyICpidWYpCit7CisJcmV0dXJuIGJsa3pvbmVkX21vdmVfem9u
ZV93cCh0ZCwgZiwgeiwgbGVuZ3RoLCBidWYpOworfQorCitzdGF0aWMgaW50IGZpb19pb3Jpbmdf
Y21kX2dldF96b25lZF9tb2RlbChzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLAorCQkJCQkgIHN0cnVj
dCBmaW9fZmlsZSAqZiwKKwkJCQkJICBlbnVtIHpiZF96b25lZF9tb2RlbCAqbW9kZWwpCit7CisJ
cmV0dXJuIGZpb19udm1lX2dldF96b25lZF9tb2RlbCh0ZCwgZiwgbW9kZWwpOworfQorCitzdGF0
aWMgaW50IGZpb19pb3JpbmdfY21kX3JlcG9ydF96b25lcyhzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRk
LAorCQkJCSAgICAgICBzdHJ1Y3QgZmlvX2ZpbGUgKmYsIHVpbnQ2NF90IG9mZnNldCwKKwkJCQkg
ICAgICAgc3RydWN0IHpiZF96b25lICp6YmR6LAorCQkJCSAgICAgICB1bnNpZ25lZCBpbnQgbnJf
em9uZXMpCit7CisJcmV0dXJuIGZpb19udm1lX3JlcG9ydF96b25lcyh0ZCwgZiwgb2Zmc2V0LCB6
YmR6LCBucl96b25lcyk7Cit9CisKK3N0YXRpYyBpbnQgZmlvX2lvcmluZ19jbWRfcmVzZXRfd3Ao
c3RydWN0IHRocmVhZF9kYXRhICp0ZCwgc3RydWN0IGZpb19maWxlICpmLAorCQkJCSAgIHVpbnQ2
NF90IG9mZnNldCwgdWludDY0X3QgbGVuZ3RoKQoreworCXJldHVybiBmaW9fbnZtZV9yZXNldF93
cCh0ZCwgZiwgb2Zmc2V0LCBsZW5ndGgpOworfQorCitzdGF0aWMgaW50IGZpb19pb3JpbmdfY21k
X2dldF9tYXhfb3Blbl96b25lcyhzdHJ1Y3QgdGhyZWFkX2RhdGEgKnRkLAorCQkJCQkgICAgIHN0
cnVjdCBmaW9fZmlsZSAqZiwKKwkJCQkJICAgICB1bnNpZ25lZCBpbnQgKm1heF9vcGVuX3pvbmVz
KQoreworCXJldHVybiBmaW9fbnZtZV9nZXRfbWF4X29wZW5fem9uZXModGQsIGYsIG1heF9vcGVu
X3pvbmVzKTsKK30KKwogc3RhdGljIHN0cnVjdCBpb2VuZ2luZV9vcHMgaW9lbmdpbmVfdXJpbmcg
PSB7CiAJLm5hbWUJCQk9ICJpb191cmluZyIsCiAJLnZlcnNpb24JCT0gRklPX0lPT1BTX1ZFUlNJ
T04sCkBAIC0xNjcwLDYgKzE3OTAsMTIgQEAgc3RhdGljIHN0cnVjdCBpb2VuZ2luZV9vcHMgaW9l
bmdpbmVfdXJpbmcgPSB7CiAJLm9wZW5fZmlsZQkJPSBmaW9faW9yaW5nX29wZW5fZmlsZSwKIAku
Y2xvc2VfZmlsZQkJPSBmaW9faW9yaW5nX2Nsb3NlX2ZpbGUsCiAJLmdldF9maWxlX3NpemUJCT0g
Z2VuZXJpY19nZXRfZmlsZV9zaXplLAorCS5nZXRfem9uZWRfbW9kZWwJPSBmaW9faW9yaW5nX2dl
dF96b25lZF9tb2RlbCwKKwkucmVwb3J0X3pvbmVzCQk9IGZpb19pb3JpbmdfcmVwb3J0X3pvbmVz
LAorCS5yZXNldF93cAkJPSBmaW9faW9yaW5nX3Jlc2V0X3dwLAorCS5nZXRfbWF4X29wZW5fem9u
ZXMJPSBmaW9faW9yaW5nX2dldF9tYXhfb3Blbl96b25lcywKKwkuZmluaXNoX3pvbmUJCT0gZmlv
X2lvcmluZ19maW5pc2hfem9uZSwKKwkubW92ZV96b25lX3dwCQk9IGZpb19pb3JpbmdfbW92ZV96
b25lX3dwLAogCS5vcHRpb25zCQk9IG9wdGlvbnMsCiAJLm9wdGlvbl9zdHJ1Y3Rfc2l6ZQk9IHNp
emVvZihzdHJ1Y3QgaW9yaW5nX29wdGlvbnMpLAogfTsKQEAgLTE2OTIsNiArMTgxOCw5IEBAIHN0
YXRpYyBzdHJ1Y3QgaW9lbmdpbmVfb3BzIGlvZW5naW5lX3VyaW5nX2NtZCA9IHsKIAkub3Blbl9m
aWxlCQk9IGZpb19pb3JpbmdfY21kX29wZW5fZmlsZSwKIAkuY2xvc2VfZmlsZQkJPSBmaW9faW9y
aW5nX2NtZF9jbG9zZV9maWxlLAogCS5nZXRfZmlsZV9zaXplCQk9IGZpb19pb3JpbmdfY21kX2dl
dF9maWxlX3NpemUsCisJLmdldF96b25lZF9tb2RlbAk9IGZpb19pb3JpbmdfY21kX2dldF96b25l
ZF9tb2RlbCwKKwkucmVwb3J0X3pvbmVzCQk9IGZpb19pb3JpbmdfY21kX3JlcG9ydF96b25lcywK
KwkucmVzZXRfd3AJCT0gZmlvX2lvcmluZ19jbWRfcmVzZXRfd3AsCisJLmdldF9tYXhfb3Blbl96
b25lcwk9IGZpb19pb3JpbmdfY21kX2dldF9tYXhfb3Blbl96b25lcywKIAkub3B0aW9ucwkJPSBv
cHRpb25zLAogCS5vcHRpb25fc3RydWN0X3NpemUJPSBzaXplb2Yoc3RydWN0IGlvcmluZ19vcHRp
b25zKSwKIAkuZmRwX2ZldGNoX3J1aHMJCT0gZmlvX2lvcmluZ19jbWRfZmV0Y2hfcnVocywg
--0000000000003199080648369f7d--
