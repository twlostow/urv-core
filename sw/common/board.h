/*
 * DSI Shield
 *
 * Copyright (C) 2013-2014 twl
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* board.h - system/hardware definitions */

#ifndef __BOARD_H
#define __BOARD_H

#include <stdint.h>

#define BASE_CLOCK 62500000 // Xtal frequency

#define BASE_UART 0x20000
#define BASE_GPIO 0x21000

#define UART_BAUDRATE 115200

static inline void writel ( uint32_t reg, uint32_t val)
{
	*(volatile uint32_t *)(reg) = val;
}

static inline uint32_t readl ( uint32_t reg )
{
	return *(volatile uint32_t *)(reg);
}

#endif
