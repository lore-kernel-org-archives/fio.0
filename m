Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:62111 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3BOQr3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Feb 2013 11:47:29 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so3662309lab.14
        for <fio@vger.kernel.org>; Fri, 15 Feb 2013 08:47:27 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 15 Feb 2013 11:47:26 -0500
Message-ID: <CABYizF+OSmz2t=1TgZEEfYFYZGwO_2r3ttrN0eMZYNxnZ1qJxA@mail.gmail.com>
Subject: How do I interpret this message bug or hardware errors
From: brian arb <brianjamesarb@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

FIO Version: fio-2.0.13-29-ga240e

+ /usr/bin/fio --minimal --readwrite=write --blocksize=65536
--ioengine=libaio --direct=1 --buffered=0 --iodepth=64
--verify=crc32c-intel --verify_backlog=1024 --verify_fatal=1
--name=verify_sda --new_group --filename=/dev/sda --ioengine=libaio
--direct=1 --buffered=0 --iodepth=64 --verify=crc32c-intel
--verify_backlog=1024 --verify_fatal=1 --name=verify_sdb --new_group
--filename=/dev/sdb --ioengine=libaio --direct=1 --buffered=0
--iodepth=64 --verify=crc32c-intel --verify_backlog=1024
--verify_fatal=1 --name=verify_sdc --new_group --filename=/dev/sdc
--ioengine=libaio --direct=1 --buffered=0 --iodepth=64
--verify=crc32c-intel --verify_backlog=1024 --verify_fatal=1
--name=verify_sdd --new_group --filename=/dev/sdd --ioengine=libaio
--direct=1 --buffered=0 --iodepth=64 --verify=crc32c-intel
--verify_backlog=1024 --verify_fatal=1 --name=verify_sde --new_group
--filename=/dev/sde --ioengine=libaio --direct=1 --buffered=0
--iodepth=64 --verify=crc32c-intel --verify_backlog=1024
--verify_fatal=1 --name=verify_sdf --new_group --filename=/dev/sdf
--ioengine=libaio --direct=1 --buffered=0 --iodepth=64
--verify=crc32c-intel --verify_backlog=1024 --verify_fatal=1
--name=verify_sdg --new_group --filename=/dev/sdg --ioengine=libaio
--direct=1 --buffered=0 --iodepth=64 --verify=crc32c-intel
--verify_backlog=1024 --verify_fatal=1 --name=verify_sdh --new_group
--filename=/dev/sdh
verify: bad magic header 0, wanted acca at file /dev/sda offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sda offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74121216, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74186752, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74252288, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74317824, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74383360, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74448896, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74514432, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74579968, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74645504, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74711040, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74776576, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74842112, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74907648, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
74973184, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75038720, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75104256, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75169792, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75235328, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75300864, length 0
verify: bad magic header 0, wanted acca at file /dev/sde offset
75366400, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74121216, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74186752, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74252288, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74317824, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74383360, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74448896, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74514432, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74579968, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74645504, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74711040, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74776576, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74842112, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74907648, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
74973184, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75038720, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75104256, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75169792, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75235328, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75300864, length 0
verify: bad magic header 0, wanted acca at file /dev/sdd offset
75366400, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74121216, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74186752, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74252288, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74317824, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74383360, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74448896, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74514432, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74579968, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74645504, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74711040, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74776576, length 0
verify: bad magic header 0, wanted acca at file /dev/sdh offset
74842112, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74121216, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74186752, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74252288, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74317824, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74383360, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74448896, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74514432, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74579968, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74645504, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74711040, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74776576, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74842112, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74907648, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
74973184, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75038720, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75104256, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75169792, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75235328, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75300864, length 0
verify: bad magic header 0, wanted acca at file /dev/sdb offset
75366400, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sdf offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71237632, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72482816, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72548352, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72613888, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72679424, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72744960, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72810496, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72876032, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
72941568, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73007104, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73072640, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73138176, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73203712, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73269248, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73334784, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73400320, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73465856, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73531392, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73596928, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73662464, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73728000, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73793536, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73859072, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73924608, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
73990144, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74055680, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74121216, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74186752, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74252288, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74317824, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74383360, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74448896, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74514432, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74579968, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74645504, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74711040, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74776576, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74842112, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74907648, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
74973184, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75038720, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75104256, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75169792, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75235328, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75300864, length 0
verify: bad magic header 0, wanted acca at file /dev/sdg offset
75366400, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71303168, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71368704, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71434240, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71499776, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71565312, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71630848, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71696384, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71761920, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71827456, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71892992, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
71958528, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72024064, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72089600, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72155136, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72220672, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72286208, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72351744, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72417280, length 0
verify: bad magic header 0, wanted acca at file /dev/sdc offset
72482816, length 0
