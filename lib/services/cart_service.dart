import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:relax_doc/models/cart_item.dart';
import 'package:relax_doc/services/token_store.dart';

class CartService {
  static final ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  static Future<String> _key() async {
    final token = await TokenStore.getToken();
    final suffix = (token ?? 'guest').hashCode.toRadixString(16);
    return 'cart_$suffix';
    
  }

  static Future<List<CartItem>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final k = await _key();
    final raw = prefs.getString(k);
    if (raw == null || raw.isEmpty) return [];
    try {
      final items = CartItem.decodeList(raw);
      // keep notifier fresh when read happens
      _updateCount(items);
      return items;
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final k = await _key();
    await prefs.setString(k, CartItem.encodeList(items));
    _updateCount(items);
  }

  static Future<void> clear() async {
    await _save([]);
  }

  static Future<void> addOrIncrement(CartItem item) async {
    final items = await getItems();
    final idx = items.indexWhere((e) => e.productId == item.productId);
    if (idx == -1) {
      items.add(item);
    } else {
      final existing = items[idx];
      items[idx] = existing.copyWith(quantity: existing.quantity + item.quantity);
    }
    await _save(items);
  }

  static Future<void> setQuantity(int productId, int qty) async {
    final items = await getItems();
    final idx = items.indexWhere((e) => e.productId == productId);
    if (idx == -1) return;
    if (qty <= 0) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(quantity: qty);
    }
    await _save(items);
  }

  static Future<void> remove(int productId) async {
    final items = await getItems();
    items.removeWhere((e) => e.productId == productId);
    await _save(items);
  }

  static Future<num> subtotalMrp() async {
    final items = await getItems();
    num sum = 0;
    for (final it in items) {
      sum += (it.mrp ?? it.price) * it.quantity;
    }
    return sum;
  }

  static Future<num> subtotalPayable() async {
    final items = await getItems();
    num sum = 0;
    for (final it in items) {
      sum += it.price * it.quantity;
    }
    return sum;
  }

  static Future<void> refreshCount() async {
    final items = await getItems();
    _updateCount(items);
  }

  static void _updateCount(List<CartItem> items) {
    final c = items.fold<int>(0, (acc, e) => acc + e.quantity);
    if (cartCount.value != c) cartCount.value = c;
  }
}
