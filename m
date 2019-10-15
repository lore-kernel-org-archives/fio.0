Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f174.google.com ([209.85.208.174]:36477 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730002AbfJOVg6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Oct 2019 17:36:58 -0400
Received: by mail-lj1-f174.google.com with SMTP id v24so21801532ljj.3
        for <fio@vger.kernel.org>; Tue, 15 Oct 2019 14:36:56 -0700 (PDT)
MIME-Version: 1.0
From: smitha sunder <sundersmitha@gmail.com>
Date: Tue, 15 Oct 2019 14:36:44 -0700
Message-ID: <CA+zhgFSzBaH3q8TGZCet4WujqYBNqNA_kH3HavLoQY8FsmKFcQ@mail.gmail.com>
Subject: unaligned IO and starting LBA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello,



I have a 512 byte formatted nvme drive and I want to send an unaligned
IO and here=E2=80=99s the fio command line I am using , fio version fio-3.7

# fio --name=3Djob1 --filename=3D/dev/nvme0n1  --rw=3Drandwrite
--ioengine=3Dlibaio  --number_ios=3D1 --debug=3Dio --bs_unaligned=3D1
--bs=3D1029

Starting 1 process

io       24015 drop page cache /dev/nvme0n1
io       24015 fill: io_u 0x8c9bc0:
off=3D0x1af7af9cec,len=3D0x405,ddir=3D1,file=3D/dev/nvme0n1
io       24015 prep: io_u 0x8c9bc0:
off=3D0x1af7af9cec,len=3D0x405,ddir=3D1,file=3D/dev/nvme0n1
io       24015 prep: io_u 0x8c9bc0: ret=3D0
io       24015 queue: io_u 0x8c9bc0:
off=3D0x1af7af9cec,len=3D0x405,ddir=3D1,file=3D/dev/nvme0n1
io       24015 calling ->commit(), depth 1
io       24015 io_u_queued_complete: min=3D1
io       24015 getevents: 1
io       24015 complete: io_u 0x8c9bc0:
off=3D0x1af7af9cec,len=3D0x405,ddir=3D1,file=3D/dev/nvme0n1
io       24015 close ioengine libaio
io       24015 free ioengine libaio



Node             SN                   Model
        Namespace Usage                      Format           FW Rev

---------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------

/dev/nvme0n1     160401RICHC01        PM1733V4TLC
        1           0.00   B /   1.92  TB    512   B +  0 B   NQ52
/dev/nvme1n1     160401RICHC01        PM1733V4TLC
        1           0.00   B /   1.92  TB    512   B +  0 B   NQ52



Shouldn=E2=80=99t I see D7BD7CE as the starting LBA for the write based on =
the
above offset (0x1af7af9cec) ?



From the PCI trace I see two writes with D7BD7C8 and D7BD7D0 as LBAs,
I am not sure why that is, any help is greatly appreciated :

; Write; Good; 11.345_5; 0; D7BD7C8; 1000; B008B; 0000; xxxx:A824;
00:10.336_991_850_0; 49.864_0; PCIe Expert Target(1:1:2);
; Write; Good; 13.761_5; 0; D7BD7D0; 1000; B008C; 0000; xxxx:A824;
00:10.336_995_406_0; 3.556_0; PCIe Expert Target(1:1:2);
; Identify; Good; 96359.046_9; 0;; 1000; 12; 0000; xxxx:A824;
00:10.433_423_218_0; 96427.812_0; PCIe Expert Target(1:1:2;
; Identify; Good; 41.635_5; 0;; 1000; 13; 0000; xxxx:A824;
00:10.439_182_147_0; 5758.929_0; PCIe Expert Target(1:1:2);

Thanks
smitha

