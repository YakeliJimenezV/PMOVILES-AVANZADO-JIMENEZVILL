import CoreData

/// Operations on the container's viewContext must run on the main actor.
/// Insert, edit or delete objects, then call save() to persist the changes.
@MainActor
final class PersistenceRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        precondition(context.concurrencyType == .mainQueueConcurrencyType)
        self.context = context
    }

    func fetch<T: NSManagedObject>(
        _ request: NSFetchRequest<T>
    ) throws -> [T] {
        try context.fetch(request)
    }

    func insert<T: NSManagedObject>(_ type: T.Type) -> T {
        T(context: context)
    }

    func delete(_ object: NSManagedObject) {
        precondition(object.managedObjectContext === context)
        context.delete(object)
    }

    /// Propagates validation errors, including Deny rules, to the caller.
    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    /// Explicitly discards all pending changes after a failed or cancelled edit.
    func rollback() {
        context.rollback()
    }
}
