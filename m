Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2BXPm7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Feb 2012 10:42:59 -0500
Message-ID: <4F47B001.5070308@kernel.dk>
Date: Fri, 24 Feb 2012 16:42:57 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: gfio branch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Stephen Cameron <stephenmcameron@gmail.com>

Hi everyone,

Stephen has been working on getting a gtk2 GUI frontend for fio going.
It's still in pretty basic shape, but I have committed the code in case
others are interested in this (or want to help out, even). It sits in
the gfio branch, once we get a bit further I'll pull it into the default
branch. It doesn't build gfio by default, only the cli fio. To build
gfio, you'll have to do:

$ make gfio

and ensure that you have gtk2 development libraries installed.

Right now it requires you to manually run a

$ ./fio --server

in a separate xterm to launch the backend, and provide a fio job file
that you want to run. The end goal is having the ability to
import/export job files, and having the various options nicely presented
in a suitable format in the GUI itself. There will be a basic layout for
quick testing, and an advanced layout with everything there. There will
be graphical reprentations of end results and ETA, and a way to save
those.

At least that's the plan, going forward. Feel free to pitch in, with
either ideas or patches. It's very much all up in the air at the moment,
now's a great time and chance to contribute!

-- 
Jens Axboe

