import { FlatList, StyleSheet, Text, View } from "react-native";

interface Item {
  id: string;
  title: string;
}

const DATA: Item[] = [
  { id: "1", title: "First Item" },
  { id: "2", title: "Second Item" },
  { id: "3", title: "Third Item" },
];

function ItemRow({ item }: { item: Item }) {
  return (
    <View style={styles.item}>
      <Text style={styles.title}>{item.title}</Text>
    </View>
  );
}

export default function MyList() {
  return (
    <FlatList
      data={DATA}
      keyExtractor={(item) => item.id}
      renderItem={({ item }) => <ItemRow item={item} />}
      contentContainerStyle={styles.container}
    />
  );
}

const styles = StyleSheet.create({
  container: { padding: 16 },
  item: {
    backgroundColor: "#1e1e2e",
    padding: 12,
    marginVertical: 6,
    borderRadius: 8,
  },
  title: { color: "#cdd6f4", fontSize: 16 },
});
