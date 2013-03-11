Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49761 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3CKQQO (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Mar 2013 12:16:14 -0400
Received: by mail-lb0-f177.google.com with SMTP id go11so3200938lbb.22
        for <fio@vger.kernel.org>; Mon, 11 Mar 2013 09:16:09 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 11 Mar 2013 20:15:49 +0400
Message-ID: <CANvN+ekLXVeKh3t9x23G-AOa9tEOBF+PY=WZB6qp8CEZPzzGJw@mail.gmail.com>
Subject: TRIM addressing unwritten space?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I may be misreading the fio code, but it looks like there is an issue
with generation of the offset to ttrim if trim_backlog option is not
set.

In this case, get_io_u falls through the check_get_trim (which starts
with the check if td->flags has TD_F_TRIM_BACKLOG set  and immediately
returns if not), and the call chain is then

set_io_u_file->fill_io_u->set_rw_dir->get_rw_dir

where, in the last else clause of the conditional, ddir is set to DDIR_TRIM.

Subsequently, the get_next_offset then - say, in the random I/O case -
ends up in the __get_next_rand_offset returning a random offset not
necessarily written to previously. TRIMming an unwritten space is not
necessarily a bug (although some SSD controllers may have different
view), but is hardly the operation fio intended to perform.

The very next portion of the __get_next_rand_offset, dealing with  the
random map, could have solved the issue (if it's real), with the write
logic reversed for TRIM (return if the offset is busy and look up the
next busy offset otherwise). For this to work, o_randommap should be
made required for trim jobs without o_trim_backlog set.

Regards,
Andrey
