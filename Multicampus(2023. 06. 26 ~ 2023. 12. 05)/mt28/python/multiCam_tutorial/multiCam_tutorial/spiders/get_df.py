import pandas as pd
def main():
    data = pd.read_json("popluation.json")
    data = pd.DataFrame(data)

    print(data.head())

if __name__ == "__main__":
    main()