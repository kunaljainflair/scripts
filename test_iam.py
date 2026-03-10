import requests

BASE_URL = "http://localhost:8040/api/iam/tenant/domain/resolve"

# ---- Test Cases ----
test_cases = [
    {
        "name": "✅ X-Original-URL only (happy path)",
        "headers": {
            "X-Original-URL": "http://nike.brand.com/api/products"
        }
    },
    {
        "name": "✅ X-Original-URL with HTTPS",
        "headers": {
            "X-Original-URL": "https://adidas.brand.com/api/orders"
        }
    },
    {
        "name": "✅ X-Forwarded-Host fallback (no X-Original-URL)",
        "headers": {
            "X-Forwarded-Host": "puma.brand.com"
        }
    },
    {
        "name": "✅ X-Forwarded-Host with multiple values",
        "headers": {
            "X-Forwarded-Host": "reebok.brand.com, proxy.internal"
        }
    },
    {
        "name": "✅ Host header fallback",
        "headers": {
            "Host": "newbalance.brand.com"
        }
    },
    {
        "name": "✅ Localhost with port (X-Original-URL)",
        "headers": {
            "X-Original-URL": "http://localhost:8081/api/test"
        }
    },
    {
        "name": "✅ All headers present (priority check — X-Original-URL should win)",
        "headers": {
            "X-Original-URL": "http://nike.brand.com/api/test",
            "X-Forwarded-Host": "adidas.brand.com",
            "Host": "puma.brand.com"
        }
    },
    {
        "name": "⚠️ Malformed X-Original-URL (should fallback)",
        "headers": {
            "X-Original-URL": "not-a-valid-url",
            "X-Forwarded-Host": "fallback.brand.com"
        }
    },
    {
        "name": "⚠️ X-Original-URL with no host (should fallback)",
        "headers": {
            "X-Original-URL": "/just/a/path"
        }
    },
    {
        "name": "❌ No headers at all (should fail with 400)",
        "headers": {}
    },
    {
        "name": "❌ X-Original-URL blank (should fallback or fail)",
        "headers": {
            "X-Original-URL": "   "
        }
    },
]


def run_tests():
    print(f"\n{'='*65}")
    print(f"  Testing: {BASE_URL}")
    print(f"{'='*65}\n")

    for i, test in enumerate(test_cases, 1):
        print(f"[{i:02d}] {test['name']}")
        print(f"      Headers sent: {test['headers']}")

        try:
            response = requests.get(BASE_URL, headers=test["headers"], timeout=5)
            print(f"      Status : {response.status_code}")

            try:
                body = response.json()
                print(f"      Response: {body}")
            except Exception:
                print(f"      Response: {response.text}")

        except requests.exceptions.ConnectionError:
            print("      ❌ Connection refused — is the server running?")
        except requests.exceptions.Timeout:
            print("      ❌ Request timed out")
        except Exception as e:
            print(f"      ❌ Unexpected error: {e}")

        print()


if __name__ == "__main__":
    run_tests()
